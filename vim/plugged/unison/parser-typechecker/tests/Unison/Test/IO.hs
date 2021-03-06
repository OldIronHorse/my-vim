{-# Language OverloadedStrings #-}
{-# Language QuasiQuotes #-}
{-# Language TypeApplications #-}

module Unison.Test.IO where

import Unison.Prelude
import EasyTest
import qualified System.IO.Temp as Temp
import qualified Data.Text as Text
import qualified Data.Text.IO as TextIO
import Shellmet ()
import Data.String.Here (iTrim)
import System.FilePath ((</>))
import System.Directory (removeDirectoryRecursive)

import Unison.Codebase (Codebase, CodebasePath)
import qualified Unison.Codebase.Branch as Branch
import qualified Unison.Codebase.FileCodebase as FC
import qualified Unison.Codebase.TranscriptParser as TR
import Unison.Parser (Ann)
import Unison.Symbol (Symbol)

-- * IO Tests

test :: Test ()
test = scope "IO" . tests $ [ testHandleOps ]

-- * Implementation

-- | Test reading from and writing to a handle
--
-- The transcript writes expectedText to a file, reads the same file and
-- writes the read text to the result file which is then checked by the haskell.
testHandleOps :: Test ()
testHandleOps = withScopeAndTempDir "handleOps" $ \workdir codebase cache -> do
  let myFile = workdir </> "handleOps.txt"
      resultFile = workdir </> "handleOps.result"
      expectedText = "Good Job!" :: Text.Text
  runTranscript_ workdir codebase cache [iTrim|
```ucm:hide
.> builtins.mergeio
```

```unison
main : '{IO} ()
main = 'let
  fp = ${Text.pack myFile}
  res = ${Text.pack resultFile}
  expected = ${expectedText}

  -- Write to myFile
  h1 = builtins.io.openFile (FilePath fp) Write
  putText h1 expected
  builtins.io.closeFile h1

  -- Read from myFile
  h2 = builtins.io.openFile (FilePath fp) Read
  myC = getText h2
  builtins.io.closeFile h2

  -- Write what we read from myFile to resultFile
  h3 = builtins.io.openFile (FilePath res) Write
  putText h3 myC
  builtins.io.closeFile h3
```

```ucm
.> run main
```
|]

  res <- io $ TextIO.readFile (resultFile)
  if res == expectedText
    then ok
    else crash $ "Failed to read expectedText from file: " ++ show myFile

-- * Utilities

initCodebase :: Branch.Cache IO -> FilePath -> String -> IO (CodebasePath, Codebase IO Symbol Ann)
initCodebase branchCache tmpDir name = do
  let codebaseDir = tmpDir </> name
  c <- FC.initCodebase branchCache codebaseDir
  pure (codebaseDir, c)

-- run a transcript on an existing codebase
runTranscript_ :: MonadIO m => FilePath -> Codebase IO Symbol Ann -> Branch.Cache IO -> String -> m ()
runTranscript_ tmpDir c branchCache transcript = do
  let configFile = tmpDir </> ".unisonConfig"
  let cwd = tmpDir </> "cwd"
  let err err = error $ "Parse error: \n" <> show err

  -- parse and run the transcript
  flip (either err) (TR.parse "transcript" (Text.pack transcript)) $ \stanzas ->
    void . liftIO $ TR.run cwd configFile stanzas c branchCache >>= traceM . Text.unpack

withScopeAndTempDir :: String -> (FilePath -> Codebase IO Symbol Ann -> Branch.Cache IO -> Test ()) -> Test ()
withScopeAndTempDir name body = scope name $ do
  tmp <- io (Temp.getCanonicalTemporaryDirectory >>= flip Temp.createTempDirectory name)
  cache <- io $ Branch.boundedCache 4096
  (_, codebase) <- io $ initCodebase cache tmp "user"
  body tmp codebase cache
  io $ removeDirectoryRecursive tmp

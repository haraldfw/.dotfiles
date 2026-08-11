{ ... }:
{
  home.file."Library/KeyBindings/DefaultKeyBinding.dict".text = ''
    {
        /* Remap Home / End keys to be correct */
        "\UF729" = "moveToBeginningOfLine:"; /* Home */
        "\UF72B" = "moveToEndOfLine:"; /* End */
        "$\UF729" = "moveToBeginningOfLineAndModifySelection:"; /* Shift + Home */
        "$\UF72B" = "moveToEndOfLineAndModifySelection:"; /* Shift + End */
        "^\UF729" = "moveToBeginningOfDocument:"; /* Ctrl + Home */
        "^\UF72B" = "moveToEndOfDocument:"; /* Ctrl + End */
        "$^\UF729" = "moveToBeginningOfDocumentAndModifySelection:"; /* Shift + Ctrl + Home */
        "$^\UF72B" = "moveToEndOfDocumentAndModifySelection:"; /* Shift + Ctrl + End */

        /* Ctrl + Left/Right = word jump, matching Windows/Linux */
        "^\UF702" = "moveWordBackward:"; /* Ctrl + Left */
        "^\UF703" = "moveWordForward:"; /* Ctrl + Right */
        "^$\UF702" = "moveWordBackwardAndModifySelection:"; /* Shift + Ctrl + Left */
        "^$\UF703" = "moveWordForwardAndModifySelection:"; /* Shift + Ctrl + Right */
    }
  '';
}

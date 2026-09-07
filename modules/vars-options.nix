{ lib, ... }:

{
    options = {
        vars.updateStream = lib.mkOption {
            default = "failStream";
        };
    };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.fancontrol;
  configFile = pkgs.writeText "fan.conf" cfg.config;

in {

  options.hardware.fancontrol = {
    enable = mkEnableOption "fancontrol (requires fancontrol.config)";

    config = mkOption {
      type = types.lines;
      default = null;
      example = ''
        # Configuration file generated by pwmconfig
        INTERVAL=1
        DEVPATH=hwmon0=devices/platform/nct6775.656 hwmon1=devices/pci0000:00/0000:00:18.3
        DEVNAME=hwmon0=nct6779 hwmon1=k10temp
        FCTEMPS=hwmon0/pwm2=hwmon1/temp1_input
        FCFANS=hwmon0/pwm2=hwmon0/fan2_input
        MINTEMP=hwmon0/pwm2=25
        MAXTEMP=hwmon0/pwm2=60
        MINSTART=hwmon0/pwm2=25
        MINSTOP=hwmon0/pwm2=10
        MINPWM=hwmon0/pwm2=0
        MAXPWM=hwmon0/pwm2=255
      '';
      description = "Contents for configuration file. See <citerefentry><refentrytitle>pwmconfig</refentrytitle><manvolnum>8</manvolnum></citerefentry>.";
    };
  };


  config = mkIf cfg.enable {
    systemd.services.fancontrol = {
      description = "Fan speed control from lm_sensors";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lm_sensors}/bin/fancontrol ${configFile}";
      };
    };
  };
}

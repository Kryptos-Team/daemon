# daemon

`daemon` is the command line tool for quick, simple deployment and management of Crypto-currency daemon.

## Main features

- [x] Installer
- [x] Updater
- [ ] Monitor
- [ ] Alerts
- [ ] Backup
- [x] Console
- [ ] Daemon Details

## Compatibility

`daemon` will run on popular distributions as long as minimum requirements are met.

- [x] Ubuntu
- [x] Debian

Other distributions are likely to work but are not fully tested.

## Installation

`daemon` allows for the simple installation of coin daemons. The installer is designed to get a daemon to a working state allowing to be started right away.

The installer will:

- Create required directories
- Install/advise on required dependencies
- Download the daemon related files
- Load configuration files

### Standard Install

The standard installation is the default installation method that requires user interaction.

### Auto install

Auto install is useful for automatic server deployments as no user prompt is required.

### Installation

1. Download the installer from github

```sh
wget https://raw.githubusercontent.com/Kryptos-Team/daemon/master/install.sh
```

2. Make your script executable

```sh
chmod +x install.sh
```

3. Run the install command

```sh
./install.sh install
```

4. Follow on-screen instructions.

## Commands

Replace ./daemon with the actual script name. Every command has a short version, also listed here.

| Command Name  | Command                | Short       |
|---------------|------------------------|-------------|
| Install       | ./daemon install       | ./daemon i  |
| Auto Install  | ./daemon auto-install  | ./daemon ai |
| Start         | ./daemon start         | ./daemon st |
| Stop          | ./daemon stop          | ./daemon sp |
| Restart       | ./daemon restart       | ./daemon r  |
| Update Coin   | ./daemon update-coin   | ./daemon uc |
| Update Daemon | ./daemon update-daemon | ./daemon ud |
| Wipe          | ./daemon wipe          | ./daemon w  |

## Donate

If you would like to donate to the project, there are several ways you can via:

- BTC: `3542EMxkgirJBbWN33NqUCPhZ89vvjeWsR`
- LTC: `LTSsbhiP3nAUanq7cPbGXfDNuxPr8VMvv1`
- XMR: `8BqPZB339MkZaJ7SLSW31vJ9zqdfL5YTTHYVrVU2i11newcLyXmnBoy5Ku72xzMrEta6hoVhymVZxesVvaR2knAR9qXxfRx`
- Paypal: `https://paypal.me/abhimanyusaharan`

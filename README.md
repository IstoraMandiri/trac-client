# Asset Tracker Registration

## Develop

```
$ cd ./app
$ meteor run --settings settings.json
```

## Build

Client only Meteor Depoyment

```
$ [sudo] npm install -g meteor-build-client
$ cd ./app
$ meteor-build-client ../build -s ./settings.json
```

If you're running an apache server you can copy the `.htaccess` rules into the build folder or use something similar. For more information on routing with a client only Meteor app, please look at the [meteor-build-client repo](https://github.com/frozeman/meteor-build-client#making-routing-work-on-a-non-meteor-server)

## QR Codes

Take a look at this repo for a QR code generator: https://github.com/hitchcott/trac-qr-generator

## TODOs

```
- Rename app to `trac-client`
- Rename /serial -> /register
- Refactor data flow
- Add transfer route
- Landing Page
- Handle race condition with two people registering same QR code
  - Special response from get /tx/ ?
```

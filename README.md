# SecurePrint
## Dev package

SecurePrint is a working prototype / toy for an enterprise secure print system. This package
contains the Vagrant and Salt scripts for deploying a development environment for the application.

A secure print system is one that requires the user to be *phyically* at the printer in order
to print the document. This prevents confidential information be left on the printer inadvertently
and being seen or taken by unauthorized individuals.

This system solves this problem by placing a RESTful API in front of a CUPS print server and
provides a mobile app to each user. The users print to the CUPS server and the job is held
indefinitely by default. The user then physically approaches the print server with app in hand.
A low energy bluetooth beacon is attached to the printer and the app prompts the user to
release the print jobs when the user is within close proximity to the beacon. When the job
is released by the mobile app, the job is sent to the printer the user is standing near.

This approach is good for users because it's convenient - there's no need to choose
the printer to print to beforehand. The catchall printer is the only printer that needs to be
available, and then the user can just physically go to whatever printer is most convenient and
print to that one with the app. If the user's first choice is in use, they can just walk to another one without
having to wait or cancel the job or start a new job.

## Installation

1. Install [Vagrant](https://www.vagrantup.com/)
2. Clone this repo
3. (Optional) Set values on the [Pillar](http://docs.saltstack.com/en/2014.7/topics/pillar/index.html)
   if necessary
4. (Optional) Set correct udev rules for your phone in scripts/bootmeup.sh
5. Run `vagrant up webapp` for the application server
6. Configure your LDAP servers in `/var/www/cups/config.yaml` in the webapp box
7. Add some real printers to cups. Get some Low energy BT beacons to place by the printers.
   Populate them in the `printers`, `beacons`, and `beacons_printers` tables in Postgres.
8. Run `vagrant up android` for the android app environment
9. Open eclipse in the android box
10. If prompted, tell eclipse where to find the android SDKs (`/opt/eclipse/android-sdks/`)
11. Create a project from existing sources (/root/workspace/SecurePrintAndroidApp/)
12. Remove the duplicate android library from the bluetooth library's /lib directory
13. Set the value for the API server url in res/values/strings.xml

You should now be able to:

* Print a document from anywhere to the Catchapp printer in cups.
* Load up the android app and tap start scanning.
* Walk up to the printer of your choice.
* Click "print" in the app.
* Watch as your documents are printed to the printer you are near at the moment.

Caveats:

* This is a prototype / toy. There is no security configured on the cups server. Do not attempt to deploy
  to production with this configuration.
* In production you would probably want the Catchall printer discoverable in Active Directory (via samba),
  this is not configured in this package.
* In production you will probably want to lock down all ways to print directly to a particular printer.
* An interface for managing printers and beacons would be nice.
* The app only scans for beacons matching Major 375 and Minor 29. Change to fit your needs in
  MainActivityWorkflowManager.GenerateScanCallback() or (even better) change the schema to store that
  information in the beacons table, add the fields to the BeaconMap object, and dynamically check for
  it in GenerateScanCallback.
* Requires an Active Directory environment. No LDAP server is provided by this package.

## License

GPL v.2

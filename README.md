English Wikipedia ACC provisioning
================================

Note: This code is not designed for Production use; currently this is **ENTIRELY** experimental.

### Required prerequisite knowledge for using this repository
* Terraform (and Terraform Cloud)
* Ansible
* Wikimedia Cloud Services
* Blue-green deployment


### Setting up OAuth from scratch

If you're doing this from scratch, the playbook that's run to set up the instance should configure a fully-working MediaWiki instance you can use. Default credentials:
 * Username: `Admin`
 * Password: `AdminOAuth123!`

### WMCS deployment

All of the "important" code to deploy this is stored in the module enwikipedia-acc/terraform-openstack-mediawiki-oauth.

This repository defines two instances of that module - one is normally configured as count=0, the other is count=1.

To upgrade:
* Take snapshots of the app and db disks on Horizon.
* Update the module versions, image snapshot names, etc as appropriate, and set count=1 for the module which is *not* active.
* Commit the change, create a pull request. Terraform Cloud will automatically run a plan, and set the status check on the commit once the plan been run.
* Check the plan on Terraform Cloud does what you expect. If it does, merge the PR. Terraform Cloud will automatically apply the changes to WMCS.
* The instance should provision automatically via Ansible. Check the instance logs on Horizon or check /var/log/cloud-init-output.log to make sure everything finished successfully. You should see "Cloud-init finished". If it's failed, log into the instance and run the command `acc-provision` to force it to run again.
* On the instance, manually sort out things like MySQL replication from the old instance to the new instance, cut over the mysql config to the new instance.
* Update the proxy config in this TF module to point to the new module. Commit/Push/Merge/Apply again.
* Deactivate the old module by setting count=0 to save resources. Commit/Push/Merge/Apply again.


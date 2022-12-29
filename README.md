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

This repository defines two instances of that module - one for each of the blue/green environments

To upgrade:
1. Take snapshots of the db disk on Horizon. You may want to shut down MariaDB while you do this.
2. Check which environment is active in environments.auto.tfvars. Set the staging environment to the other environment.
3. Update the image snapshot name for the module which is *not* active. Update any other attributes as needed (for example, module versions, image names, etc)
4. Commit the change, create a pull request. Terraform Cloud will automatically run a plan, and set the status check on the commit once the plan been run.
5. Check the plan on Terraform Cloud does what you expect. If it does, merge the PR. Terraform Cloud will automatically apply the changes to WMCS.
6. The instance should provision automatically via Ansible. Check the instance logs on Horizon or check /var/log/cloud-init-output.log to make sure everything finished successfully. You should see "Cloud-init finished". If it's failed, log into the instance and run the command `acc-provision` to force it to run again.
7. Check the staging environment is working as you'd expect.
8. Swap the prod/staging enviroments in `environments.auto.tfvars`. Repeat steps 4 and 5.
9. Check the new instance is working well.
10. Deactivate the old prod module by setting the staging environment to null in `environments.auto.tfvars`. You may want to sync the settings between the two environments while you're at it. Repeat steps 4 and 5 again.


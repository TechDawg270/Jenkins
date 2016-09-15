/*
	Clean and reset build history for all jobs
 */

import hudson.model.*

for(item in Hudson.instance.items) {
	//THIS WILL REMOVE ALL BUILD HISTORY
	item.builds.each() { build ->
	  build.delete()
	}

	item.updateNextBuildNumber(1)
}

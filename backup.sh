function findWorlds() {
	serverdir=$1
	worlds=()
	# overworld
	if [ -d $serverdir/world ]; then
		echo Found world/, adding world/ to backup
		worlds+=(world/)
	fi
	# nether
	if [ -d $serverdir/world_nether ]; then
		echo Found world_nether/, adding world_nether/ to backup
		worlds+=(world_nether/)
	fi
	# the end
	if [ -d $serverdir/world_the_end ]; then
		echo Found world_the_end/, adding world_the_end/ to backup
		worlds+=(world_the_end/)
	fi

	worldsCount=${#worlds[@]}
	if [ ! $worldsCount -eq 0 ]; then
		echo Found $worldsCount worlds
	else
		echo No worlds found under $serverdir, enter server path via -s flag
		exit
	fi

}

function makeWorldsBackup() {
	if [ -z ${outputdir+x} ]; then
		outputdir=$(realpath ./world_backup)
	fi
	echo $outputdir
	# crrete dir if not exist
	if [ ! -d $outputdir ]; then
		mkdir $outputdir
	fi

	filepath="$outputdir/$1.zip"
	cd $serverdir
	zip -r $filepath ${worlds[@]}

	if [ ! $gpg_public ]; then
		gpg --output $filepath.gpg --encrypt --recipient $gpg_public
	fi
	cd -
}

function webDavUpload() {
	local filePathToUpload=$1
	local serverFileName=$2
	local webdavAdress=$MC_BACKUP_WEBDAV_ADRESS
	if [[ ! $webdavAdress == http* ]]; then
		echo "No protocol specified, assuming https"
		webdavAdress="https://$webdavAdress"
	fi
	echo Uploading to $webdavAdress
	curl --user $MC_BACKUP_WEBDAV_USER:$MC_BACKUP_WEBDAV_PASSWORD -T $filePathToUpload $webdavAdress/$serverFileName
}

while getopts s:o: arg; do
	case "${arg}" in
	s)
		serverdir=$(realpath ${OPTARG})
		;;
	o)
		if ! outputdir=$(realpath ${OPTARG}); then
			echo Invalid Output path
			exit
		fi
		;;
	e)
		gpg_public = ${OPTARG}
		;;
	esac
done

filename=mc-backup_$(date +"%Y-%m-%dT%H:%M:%S")
if [ -z ${serverdir+x} ]; then
	scriptPath=$(realpath .)
	findWorlds $scriptPath
	makeWorldsBackup $filename
else
	findWorlds $serverdir
	makeWorldsBackup $filename
fi
echo created $filepath

# upload to webdav server
if [ ! -z $MC_BACKUP_WEBDAV_ADRESS ]; then
	echo Uploading $filename to webdav server
	webDavUpload $filepath $filename.zip
fi

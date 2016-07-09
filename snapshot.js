var child_process = require("child_process");
var fs = require("fs");
var path = require("path");

var del_old_snapshot = function (filename) {
	fs.stat(path.resolve('./', filename), function (err, stat) {
		if (err) return;
		var mtime = new Date(stat.mtime);
		if (mtime < new Date(new Date() - 1*60000)) {
			try {
				fs.unlink(path.resolve('./', filename));
			} catch (e) {
				// LOG.error(err);
			}
		} else {
		}
	});
}

fs.readdir('./', function (err, files) {
	if (err) {
		return;
	}
	for (var i in files) {
		var filename = files[i].slice(0);
		if (filename.match(/.*png$/i)) {
			del_old_snapshot(filename);
		}
	}
});

function snapshot () {
	this.init();
	return this;
};

snapshot.prototype.init = function () {
	var self = this;

	this.old_snapshot = "";

	fs.watch("./", {presistent: true, recursive: true}, function (event, filename) {
		if (event === 'rename') {
			return;
		}

		if (filename.match(/.*png$/i)) {
			self.keepalive();
			if (self.old_snapshot === "") {

				self.old_snapshot = (path.resolve('./', filename));

			} else if (self.old_snapshot !== path.resolve('./', filename)) {
				try {
					fs.rename(self.old_snapshot, "./snapshot.jpg");
				} catch (e) {
					console.log(e);
				}
				self.old_snapshot = path.resolve('./', filename);

			}
		}
	});

	try {
		this.ffmpeg_snapshot = child_process.spawn('/usr/local/bin/ffmpeg', [
			'-y',
			'-loglevel', 'fatal',
			'-codec', 'h264_mmal',
			'-i', 'rtsp://localhost:8554/h264',
			'-r', '2',
			// '-vf', 'fps=1',
			'-vf', 'drawtext=fontfile=/usr/share/fonts/truetype/wqy/wqy-microhei.ttc : text=%{localtime\}: fontcolor=yellow@1: x=10: y=10',
			path.resolve('./', 'snapshot%01d.png')
		]);
		this.keep_rtsp = setInterval(function () {
			console.log('rtsp is dead, rrrrrrrrrrrrrrrreconnecting ... ');
			self.reconnect_rtsp();
		}, 5000);
	} catch (err) {
		console.log(err);
	}

	this.ffmpeg_snapshot.stderr.on('error', function (data) {
		console.log(data.toString());
	});

	this.ffmpeg_snapshot.stderr.on('data', function (data) {
		console.log(data.toString());
	});

	this.ffmpeg_snapshot.on('close', function(code) {
		console.log(code);
	});
}

snapshot.prototype.keepalive = function () {
	var self = this;
	if (typeof(this.keep_rtsp) !== "undefined" || typeof(this.keep_rtsp) !== {}) {
		clearInterval(this.keep_rtsp);
		delete this.keep_rtsp;
	}
	this.keep_rtsp = setInterval(function () {
		console.log('rtsp is dead, rrrrrrrrrrrrrrrreconnecting ... ');
		self.reconnect_rtsp();
	}, 5000);
}

snapshot.prototype.reconnect_rtsp = function () {
	if (typeof(this.keep_rtsp) !== "undefined" || typeof(this.keep_rtsp) !== {}) {
		clearInterval(this.keep_rtsp);
		delete this.keep_rtsp;
	}
	try {
		this.ffmpeg_snapshot.kill('SIGHUP');
	} catch (e) {
		if (e) {
			console.log(e);
			self.reconnect_rtsp();
			return;
		}
	}
	delete this.ffmpeg_snapshot;
	this.init();
}

var ss = new snapshot();

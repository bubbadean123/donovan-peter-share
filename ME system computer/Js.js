
var on = false;
var code = 0;
var booted = false;
var waitfordisk = false;
var adisk = "";
var bdisk = "";
var form = document.getElementById('computer');
var name = "";
form.log.value="";
drive="A";
$("#command").keyup(function(event){
		if(event.keyCode == 13){
				event.preventDefault();
				$("#enter").click();
		}
});

function toggle() {
	if (on) {
		poweroff();
	} else {
		poweron();
	}
}

function poweron() {
	if (!on) {
		log("Powered on");
		on = true;
		form.screen.value="Please insert valid boot disk in drive A\n";
		if (adisk == "MEOS"){
			boot();
		} else {
			waitfordisk=true;
		}
	}
}

function log(string) {
	form.log.value+=string;
	form.log.value+="\n";
}

function poweroff() {
	if (on) {
		on = false;
		boot = false;
		form.screen.value="";
		form.log.value="";
		form.A.value="";
		form.B.value="";
		adisk="";
		adisk="";
	}
}

function interpret() {
	if (booted) {
		command = form.command.value;
		form.screen.value += command+"\n";
		log("Got command "+command);
		command = command.split(" ");
		form.command.value = "";
		form.command.focus();
		if (command=="reboot") {
			poweroff();
			poweron();
		}
		if (command=="B:") {
			drive="B";
		}
		if (command=="A:") {
			drive="A";
		}
		if (command=="")
		form.screen.value += drive+">";
	}
}

function insert_a() {
	log(waitfordisk)
	adisk = form.A.value;
	if (adisk==="") {
		log("Cleared drive A");
	} else {
		log("Inserted "+adisk+" into drive A");
	}
	if (waitfordisk) {
		log("Calling boot()");
		boot();
	}
}

function insert_b() {
	bdisk = form.B.value;
	if (bdisk==="") {
		log("Cleared drive B");
	} else {
		log("Inserted "+bdisk+" into drive B");
	}
}
function boot() {
	if (adisk=="MEOS") {
		form.screen.value="MEOS V1.0\n"+drive+">";
		waitfordisk = false;
		booted = true;
	} else {
		form.screen.value="Invalid boot disk\nInsert valid boot disk in drive A"
	}
}

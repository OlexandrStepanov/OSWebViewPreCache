if(typeof(AC)==="undefined"){AC={}}AC.Detector={getAgent:function(){return navigator.userAgent.toLowerCase()
},isMac:function(b){var a=b||this.getAgent();return !!a.match(/mac/i)},isSnowLeopard:function(b){if(typeof console!="undefined"){console.warn('Instead of AC.Detector.isSnowLeopard, please use AC.Detector.macOSAtLeastVersion("10.6").')
}var a=b||this.getAgent();return !!a.match(/mac os x 10_6/i)},macOSVersion:function(d){var c=d||this.getAgent();
if(!this.isMac(c)){return null}var a=c.match(/(mac os x )([\d\._]*)/i);if(a==null){return a
}if(!!a[2].match(/\./)){a=a[2].split(".")}else{a=a[2].split("_")}for(var b=0;b<a.length;
b++){a[b]=parseInt(a[b])}return a},macOSAtLeastVersion:function(e,d){if(typeof e=="undefined"){return false
}var a=this.macOSVersion(d);if(a==null){return false}if(typeof e=="string"){e=e.replace(".","_").split("_")
}for(var c=0;c<e.length;c++){var b=parseInt(a[c]);if(isNaN(b)){b=0}if(parseInt(e[c])>b){return false
}}return true},isWin:function(b){var a=b||this.getAgent();return !!a.match(/win/i)
},winVersion:function(c){var b=c||this.getAgent();if(this.isWin(b)){var a=b.match(/nt\s*([\d\.]*)/);
if(a&&a[1]){return parseFloat(a[1])}return true}return false},winAtLeastVersion:function(c,b){if(typeof c=="undefined"){return false
}c=parseFloat(c);if(c===NaN){return false}var a=this.winVersion(b);if(a===null||a===false||a===true){return false
}return(c<=a)},isWin2k:function(b){var a=b||this.getAgent();return this.isWin(a)&&(a.match(/nt\s*5/i))
},isWinVista:function(b){var a=b||this.getAgent();return this.isWin(a)&&(a.match(/nt\s*6\.0([0-9]{0,2})?/i))
},isWebKit:function(b){if(this._isWebKit===undefined){var a=b||this.getAgent();
this._isWebKit=!!a.match(/AppleWebKit/i);this.isWebKit=function(){return this._isWebKit
}}return this._isWebKit},isSafari2:function(c){if(typeof console!="undefined"){console.warn("Instead of AC.Detector.isSafari2(), please use AC.Detector.isWebKit().")
}var b=c||this.getAgent();if(this._isSafari2===undefined){if(!this.isWebKit(b)){this._isSafari2=false
}else{var a=parseInt(parseFloat(b.substring(b.lastIndexOf("safari/")+7)),10);this._isSafari2=(a>=419)
}this.isSafari2=function(){return this._isSafari2}}return this._isSafari2},isChrome:function(b){if(this._isChrome===undefined){var a=b||this.getAgent();
this._isChrome=!!a.match(/Chrome/i);this.isChrome=function(){return this._isChrome
}}return this._isChrome},isiPhone:function(b){if(typeof console!="undefined"){console.warn("Instead of AC.Detector.isiPhone(), please use AC.Detector.isMobile().")
}var a=b||this.getAgent();return this.isMobile(a)},iPhoneOSVersion:function(d){if(typeof console!="undefined"){console.warn("Instead of AC.Detector.iPhoneOSVersion(), please use AC.Detector.iOSVersion().")
}var c=d||this.getAgent(),a=this.isMobile(c),e,f,b;if(a){var e=c.match(/.*CPU ([\w|\s]+) like/i);
if(e&&e[1]){f=e[1].split(" ");b=f[2].split("_");return b}else{return[1]}}return null
},isiPad:function(b){var a=b||this.getAgent();return !!(this.isWebKit(a)&&a.match(/ipad/i))
},isMobile:function(b){var a=b||this.getAgent();return this.isWebKit(a)&&(a.match(/Mobile/i)&&!this.isiPad(a))
},_iOSVersion:null,iOSVersion:function(){if(this._iOSVersion===null){this._iOSVersion=(AC.Detector.isMobile()||AC.Detector.isiPad())?parseFloat(navigator.userAgent.match(/os ([\d_]*)/i)[1].replace("_",".")):false
}return this._iOSVersion},isOpera:function(b){var a=b||this.getAgent();return !!a.match(/opera/i)
},isIE:function(b){var a=b||this.getAgent();return !!a.match(/msie/i)},isIEStrict:function(b){var a=b||this.getAgent();
return a.match(/msie/i)&&!this.isOpera(a)},isIE8:function(d){var c,b,a;c=d||this.getAgent();
b=c.match(/msie\D*([\.\d]*)/i);a=-1;if(b&&b[1]){a=b[1]}return(+a>=8)},isFirefox:function(b){var a=b||this.getAgent();
return !!a.match(/firefox/i)},isiTunesOK:function(b){var a=b||this.getAgent();if(this.isMac(a)){return true
}if(this.winAtLeastVersion(5.1,a)){return true}return false},_isQTInstalled:undefined,isQTInstalled:function(){if(this._isQTInstalled===undefined){var a=false;
if(navigator.plugins&&navigator.plugins.length){for(var b=0;b<navigator.plugins.length;
b++){var c=navigator.plugins[b];if(c.name.indexOf("QuickTime")>-1){a=true}}}else{if(typeof(execScript)!="undefined"){qtObj=false;
execScript('on error resume next: qtObj = IsObject(CreateObject("QuickTimeCheckObject.QuickTimeCheck.1"))',"VBScript");
a=qtObj}}this._isQTInstalled=a}return this._isQTInstalled},getQTVersion:function(){var a="0";
if(navigator.plugins&&navigator.plugins.length){for(var c=0;c<navigator.plugins.length;
c++){var d=navigator.plugins[c];var b=d.name.match(/quicktime\D*([\.\d]*)/i);if(b&&b[1]){a=b[1]
}}}else{if(typeof(execScript)!="undefined"){ieQTVersion=null;execScript('on error resume next: ieQTVersion = CreateObject("QuickTimeCheckObject.QuickTimeCheck.1").QuickTimeVersion',"VBScript");
if(ieQTVersion){a=ieQTVersion.toString(16);a=[a.charAt(0),a.charAt(1),a.charAt(2)].join(".")
}}}return a},isQTCompatible:function(c,e){function b(g,i){var f=parseInt(g[0],10);
if(isNaN(f)){f=0}var h=parseInt(i[0],10);if(isNaN(h)){h=0}if(f===h){if(g.length>1){return b(g.slice(1),i.slice(1))
}else{return true}}else{if(f<h){return true}else{return false}}}var d=c.split(/\./);
var a=e?e.split(/\./):this.getQTVersion().split(/\./);return b(d,a)},isValidQTAvailable:function(a){return this.isQTInstalled()&&this.isQTCompatible(a)
},isSBVDPAvailable:function(a){return false},_svgAsBackground:null,svgAsBackground:function(c){if(this._svgAsBackground===null){var b=function(){AC.Detector._svgAsBackground=true;
if(typeof(c)=="function"){c()}};var a=document.createElement("img");a.setAttribute("src","data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNzUiIGhlaWdodD0iMjc1Ij48L3N2Zz4%3D");
if(a.complete){a.style.visibility="hidden";a.style.position="absolute";document.body.appendChild(a);
window.setTimeout(function(){AC.Detector._svgAsBackground=false;if(a.width>=100){document.body.removeChild(a);
b()}else{document.body.removeChild(a)}},1)}else{this._svgAsBackground=false;a.onload=b
}}else{if(this._svgAsBackground&&typeof(c)=="function"){c()}}return this._svgAsBackground
},_style:null,_prefixes:null,_preFixes:null,_css:null,isCSSAvailable:function(k){if(!this._style){this._style=document.createElement("browserdetect").style
}if(!this._prefixes){this._prefixes="-webkit- -moz- -o- -ms- -khtml- ".split(" ")
}if(!this._preFixes){this._preFixes="Webkit Moz O ms Khtml ".split(" ")}if(!this._css){this._css={}
}k=k.replace(/([A-Z]+)([A-Z][a-z])/g,"$1-$2").replace(/([a-z\d])([A-Z])/g,"$1-$2").replace(/^(\-*webkit|\-*moz|\-*o|\-*ms|\-*khtml)\-/,"").toLowerCase();
switch(k){case"gradient":if(this._css.gradient!==undefined){return this._css.gradient
}var k="background-image:",g="gradient(linear,left top,right bottom,from(#9f9),to(white));",f="linear-gradient(left top,#9f9, white);";
this._style.cssText=(k+this._prefixes.join(g+k)+this._prefixes.join(f+k)).slice(0,-k.length);
this._css.gradient=(this._style.backgroundImage.indexOf("gradient")!==-1);return this._css.gradient;
case"inset-box-shadow":if(this._css["inset-box-shadow"]!==undefined){return this._css["inset-box-shadow"]
}var k="box-shadow:",h="#fff 0 1px 1px inset;";this._style.cssText=this._prefixes.join(k+h);
this._css["inset-box-shadow"]=(this._style.cssText.indexOf("inset")!==-1);return this._css["inset-box-shadow"];
default:var e=k.split("-"),a=e.length,d,c,b;if(e.length>0){k=e[0];for(c=1;c<a;c++){k+=e[c].substr(0,1).toUpperCase()+e[c].substr(1)
}}d=k.substr(0,1).toUpperCase()+k.substr(1);if(this._css[k]!==undefined){return this._css[k]
}for(b=this._preFixes.length-1;b>=0;b--){if(this._style[this._preFixes[b]+k]!==undefined||this._style[this._preFixes[b]+d]!==undefined){this._css[k]=true;
return true}}return false}return false},_supportsThreeD:false,supportsThreeD:function(){try{this._supportsThreeD=false;
if("styleMedia" in window){this._supportsThreeD=window.styleMedia.matchMedium("(-webkit-transform-3d)")
}else{if("media" in window){this._supportsThreeD=window.media.matchMedium("(-webkit-transform-3d)")
}}if(!this._supportsThreeD){if(!document.getElementById("supportsThreeDStyle")){var a=document.createElement("style");
a.id="supportsThreeDStyle";a.textContent="@media (transform-3d),(-o-transform-3d),(-moz-transform-3d),(-ms-transform-3d),(-webkit-transform-3d) { #supportsThreeD { height:3px } }";
document.querySelector("head").appendChild(a)}if(!(div=document.querySelector("#supportsThreeD"))){div=document.createElement("div");
div.id="supportsThreeD";document.body.appendChild(div)}this._supportsThreeD=(div.offsetHeight===3)
}return this._supportsThreeD}catch(b){return false}},_hasGyro:null,_testingForGyro:false,hasGyro:function(){if(this._hasGyro!==null){return this._hasGyro
}if("DeviceOrientationEvent" in window&&window.DeviceOrientationEvent!==null){if(this._testingForGyro===false){this._testingForGyro=true;
var a=this;this.boundTestingForGyro=function(b){a.testingForGyro(b)};window.addEventListener("deviceorientation",this.boundTestingForGyro,true);
this._testGyroTimeout=window.setTimeout(function(){this._hasGyro=false}.bind(this),250)
}return this._hasGyro}else{return this._hasGyro=false}},testingForGyro:function(a){if(this._hasGyro===false){return this._hasGyro
}else{if(typeof a.gamma!=="undefined"&&typeof a.beta!=="undefined"){this._hasGyro=true
}else{this._hasGyro=false}window.clearTimeout(this._testGyroTimeout);window.removeEventListener("deviceorientation",this.boundTestingForGyro,true);
delete this.boundTestingForGyro}},_isiPadWithGyro:null,isiPadWithGyro:function(){if(this._isiPadWithGyro===false||!this.isiPad()){return false
}else{return this._isiPadWithGyro=this.hasGyro()}},_hasLocalStorage:null,hasLocalStorage:function(){if(this._hasLocalStorage!==null){return this._hasLocalStorage
}try{if(typeof localStorage!=="undefined"&&"setItem" in localStorage){localStorage.setItem("ac_browser_detect","test");
this._hasLocalStorage=true;localStorage.removeItem("ac_browser_detect","test")}else{this._hasLocalStorage=false
}}catch(a){this._hasLocalStorage=false}return this._hasLocalStorage},_hasSessionStorage:null,hasSessionStorage:function(){if(this._hasSessionStorage!==null){return this._hasSessionStorage
}try{if(typeof sessionStorage!=="undefined"&&"setItem" in sessionStorage){sessionStorage.setItem("ac_browser_detect","test");
this._hasSessionStorage=true;sessionStorage.removeItem("ac_browser_detect","test")
}else{this._hasSessionStorage=false}}catch(a){this._hasSessionStorage=false}return this._hasSessionStorage
},_hasCookies:null,hasCookies:function(){if(this._hasCookies!==null){return this._hasCookies
}this._hasCookies=("cookie" in document&&!!navigator.cookieEnabled)?true:false;
return this._hasCookies}};
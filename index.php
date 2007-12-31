<html>
<head>
<title>www.austenconstable.com</title>

<SCRIPT LANGUAGE="JavaScript1.2">
name="mainwin";
path="main.php";
wname="new";

myonb=new Array();
look=new Array();
look[1]='toolbar=no,location=no,directories=no,status=no,scrollbars=no,resizable=no,copyhistory=no,titlebar=no,';

screenWidth=screen.availWidth;
screenHeight=screen.availHeight;

if (screenWidth<=800) w=screenWidth-10;
else w=650;

h=300;

x=(screenWidth-w-10)/2;
y=(screenHeight-h-40)/2;

if (x<0) x=0;
if (y<0) y=0;

function openWindow()
{
	if (document.layers)
	{
		myonb[wname]=window.open(path,wname,look[1]+'innerWidth='+w+',innerHeight='+h+',screenX='+x+',screenY='+y);
	}
	else
	{
		myonb[wname]=window.open(path,wname,look[1]+'width='+w+',height='+h);
		setTimeout('myonb["'+wname+'"].moveTo('+x+','+y+'+35)',500);
	}
}

</SCRIPT>

<link rel="stylesheet" href="inc/website.css" type="text/css">

</head>
<body bgcolor=#ffffff leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ONLOAD="openWindow();" ONUNLOAD="window.focus();">
<table width="100%" border="0" cellspacing="0" cellpadding="10" height="100%">
  <tr> 
    <td valign="top" align="left"><h1 align="left">www.austenconstable.com&nbsp;v1.2</h1></td>
  </tr>
  <tr>
    <td valign="bottom" align="right"> 
      <h1 align="right">The main window should automatically open. If it does 
        not please click <a href="javascript:openWindow();">here.</a> 
      </h1>
      <h1 align="right"> A screen resolution of at least <strong>800x600</strong> 
        is recommended. <br>
        This site has been designed to run in Netscape 6 and Internet Explorer 
        6 and has been tested on both Macintosh and Windows platforms. </h1>
      </td>
  </tr>
</table>
<?php include("inc/ganalytics.inc") ?></body>
</html>

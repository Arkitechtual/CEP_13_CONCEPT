var lastSize = 0;

var views = [];

function switchView(summaryDivId, detailsDivId, mode) {

    if ( views[summaryDivId] == null ) {
       views[summaryDivId] = 0;
    }
    var summary = document.getElementById(summaryDivId);
    var details = document.getElementById(detailsDivId);

    if ( mode == "sd" )  {
      if ( views[summaryDivId] == 0 ) {
          toggleView("showdetails", summary, details);
          views[summaryDivId] = 1;
      } else if ( views[summaryDivId] == 1 ) {
          toggleView("showsummary", summary, details);
          views[summaryDivId] = 0;
      } else if ( views[summaryDivId] == 2 ) {
          toggleView("showsummary", summary, details);
          views[summaryDivId] = 0;
      } else if ( views[summaryDivId] == 3 ) {
          toggleView("showsummary", summary, details);
          views[summaryDivId] = 0;
      }
    } else if ( mode == "pm") {
       if ( views[summaryDivId] == 0 ) {
          toggleView("hideall", summary, details);
          views[summaryDivId] = 2;
       } else if ( views[summaryDivId] == 1 ) {
           toggleView("hideall", summary, details);
           views[summaryDivId] = 3;
       } else if ( views[summaryDivId] == 2 ) {
          toggleView("showsummary", summary, details);
          views[summaryDivId] = 0;
       } else if ( views[summaryDivId] == 3 ) {
          toggleView("showdetails", summary, details);
          views[summaryDivId] = 1;
       }
    }
     if ( summary.id == "labs-results-summary" ) {
         labviews("labs-results",labResult);
    }
    if ( summary.id == "labs-summary" ) {
         labviews("labs",labResult);
    }
    if ( summary.id == 'vital-signs-summary') {
        var sb=summary.parentNode;
        sb=getElementsByClassName('switch_button',sb)[0];
        if ( views[summaryDivId] == 1 || views[summaryDivId] == 3 )  {
            sb.innerHTML="Last 4 Results";
        } else if ( views[summaryDivId] == 0 || views[summaryDivId] == 2 )  {
            sb.innerHTML="All Results";
        }
	}
}


function toggleView ( mode, summary, details ) {
    if ( mode == "hideall" )  {
         summary.style.display = 'none';
         details.style.display = 'none';
    } else if ( mode == "showsummary" )  {
         summary.style.display = 'block';
         details.style.display = 'none';
    } else if ( mode == "showdetails" )  {
         summary.style.display = 'none';
         details.style.display = 'block';
    }
}

var labResult = 0;

/* click on "past" buttons "labs-results"  or "labs" */
function labviews ( id, item ) {

    hideAllLabsResults(id);
    labResult = item;
    var mode = views[ id + "-summary"];
    if(typeof(mode)=='undefined') {
        mode=0;
    }
    if ( labResult == "" ) {
        if ( mode == 0 ) {
            toggleElement(id +"-summary", "show");
        } else if ( mode == 1 ) {
            toggleElement(id +"-details", "show");
        }
    } else if ( labResult == "1year" ) {
        if ( mode == 0 ) {
            toggleElement(id +"-summary-1year", "show");
        } else if ( mode == 1 ) {
            toggleElement(id +"-details-1year", "show");
        }
    } else if ( labResult == "18months" ) {
        if ( mode == 0 ) {
            toggleElement(id +"-summary-18months", "show");
        } else if ( mode == 1 ) {
            toggleElement(id +"-details-18months", "show");
        }
    } else if ( labResult == "2year" ) {
        if ( mode == 0 ) {
            toggleElement(id +"-summary-2year", "show");
        } else if ( mode == 1 ) {
            toggleElement(id +"-details-2year", "show");
        }
    } else if ( labResult == "3year" ) {
        if ( mode == 0 ) {
            toggleElement(id +"-summary-3year", "show");
        } else if ( mode == 1 ) {
            toggleElement(id +"-details-3year", "show");
        }
    } else if ( labResult == "all" ) {
        if ( mode == 0 ) {
            toggleElement(id + "-summary-all", "show");
        } else if ( mode == 1 ) {
            toggleElement(id + "-details-all", "show");
        }
    }

}

function hideAllLabsResults(id) {
    toggleElement(id + "-summary","hide");
    toggleElement(id + "-summary-1year","hide");
    toggleElement(id + "-summary-18months","hide");
    toggleElement(id + "-summary-2year","hide");
    toggleElement(id + "-summary-3year","hide");
    toggleElement(id + "-summary-all","hide");
    toggleElement(id + "-details","hide");
    toggleElement(id + "-details-1year","hide");
    toggleElement(id + "-details-18months","hide");
    toggleElement(id + "-details-2year","hide");
    toggleElement(id + "-details-3year","hide");
    toggleElement(id + "-details-all","hide");
}

function toggleElement(id, mode)  {
    var el = document.getElementById(id);
    var table = document.getElementById(id +"-table");
    var tbody = table.getElementsByTagName("tbody")[0];
    var rows = table.getElementsByTagName("tr");

    if((rows.length < 2) && (table.attributes.getNamedItem("count") != null)) {
        if(table.attributes.getNamedItem("count").value > 0){
        //alert("hu");
            var r = document.createElement('tr');
            var cell = document.createElement('td');
            cell.innerHTML = "Data exists in older date range";
            cell.className = 'empty-table';
            cell.colSpan = rows[0].childNodes.length;
            r.appendChild(cell);
            tbody.appendChild(r);
        }
    }

    if ( mode == "show" ) {
        el.style.display = 'block';
    } else {
        el.style.display = 'none';
    }
}


function codes(obj) {
	var codesOn=(obj.innerHTML.match('on'))?true:false;
	if  ( codesOn ) {
		obj.innerHTML="codes off";
	} else {
		obj.innerHTML="codes on";
    }
	while(obj.className!='wrap_window') {
		obj=obj.parentNode;
    }

	obj=obj.getElementsByTagName('div');
	for ( var x=0; x<obj.length; x++) {
		if (obj[x].id.match(".*-(summary|details).*")!=null) {

			var tref=new TableRef(getElementsByClassName('labdata',obj[x])[0]);
            if (tref==null || tref.table.innerHTML.match('No records found')) continue;

			if(codesOn) {
				var mp=new Map();
				for (var y=0;y<tref.table.rows.length;y++) {
					var code=tref.table.rows[y].getAttribute('code');
					if ( code != null )  {
						mp.pushData(code,y);
					} else {
						mp.pushData('NO CODE', y );
                    }
				}
				/*mp.sortAscending();*/

				var keys=mp.getKeys();
				for ( var y=0; y < keys.length; y++) {
					var data=mp.getData(keys[y]);

					var r = document.createElement('tr');
					r.className='nouse';
					r.style.background='#b7c3d0';
					var l=tref.cols();
					for ( var z=0; z<l; z++) {
					  var w = document.createElement('td');
					  w.width=tref.col(z).width;
						r.appendChild(w);
						if(z==0)
					    r.childNodes[z].innerHTML=keys[y];
					  else
					    r.childNodes[z].innerHTML=tref.row(y).childNodes[z].innerHTML;
                                        }
					tref.pushElement(r);

					for ( var z=0; z<data.length; z++ ) {
                                            tref.pushElement(tref.row(data[z]));
                                        }
				}
				tref.putTable();
			} else {
				for ( var y=0; y<tref.table.rows.length; y++) {
					if (!tref.table.rows[y].className.match('nouse')) {
						var code=tref.pushElement(tref.table.rows[y]);
					}
				}
				tref.putTable();
			}
		}
	}
}

function onLoad() {
    if(typeof checkLogin == 'function') {
        checkLogin();
    }
    hidePrintTableHeaders();
    addCurrentTimeToBanner();
    doResize();
    enableTooltips();
    initSortableTables();
    initScrollHeaders();
    initHeights();
    initPictures();
}

function hidePrintTableHeaders() {
    var arr = getElementsByClassName("sectiontable-printheaderrow",document.getElementById("content"));
    for(var x=0; x < arr.length; x++)  {
        arr[x].style.display="none";
    }

    arr = getElementsByClassName("sectiontableheaderrow",document.getElementById("content"));
    for(var x=0; x < arr.length; x++)  {
        arr[x].style.display="block";
    }
}

function initPictures() {
    if (typeof pictures !== 'undefined') {
        for (key in pictures) {
            var divs = getElementsByClassName(key);
            if (divs.length > 0) {
                var oTbl = document.createElement("Table");
                oTbl.style.borderCollapse = "collapse";
                oTbl.style.tableLayout = "fixed";
                for (var i = 0; i < pictures[key].length; i++) {
                    var oTR = oTbl.insertRow(i);
                    for (var j = 0; j < pictures[key][i].length; j++) {
                        var oTD = oTR.insertCell(j);
                        var index = pictures[key][i][j];
                        if (index != -1) {
                            oTD.bgColor = pictureColors[key][index];
                        }
                        oTD.style.padding = "0";
                        oTD.style.margin = "0";
                        oTD.style.width = "1px";
                        oTD.style.height = "1px";
                    }
                }
                divs[0].appendChild(oTbl);
                for (var k = 1; k < divs.length; k++) {
                    divs[k].appendChild(oTbl.cloneNode(true));
                }
            }
        }
    }
}

function initScrollHeaders() {
   var sections = getElementsByClassName('scrollRoot');
   for (var i = 0; i < sections.length; i++) {
      var scTable = getElementsByClassName("scrollHeaderTable", sections[i])[0];
      var scDiv = getElementsByClassName("scrollHeaderDiv", sections[i])[0];
      scDiv.onscroll = bindFunction(scrollFc, scTable, scDiv);
   }
}

function initHeights() {
    var sections = getElementsByClassName('wrap_window');
	for ( var x=0; x < sections.length; x++ ) {
        var tables = getElementsByClassName('sectiontablediv',sections[x]);
        for ( var y=0; y < tables.length; y++) {
            var table = tables[y];
            var rowlimit = table.getAttribute('rowlimit');
            if ( rowlimit != null ) {
                if ( y == 1) {
                    tables[0].parentNode.style.display='none';
                    tables[1].parentNode.style.display='block';
                }

                rowlimit = parseInt(rowlimit);
                var allRows=table.getElementsByTagName('tr');
                var rows = [];

                for (var i=0; i < allRows.length; i++) {
                    var row = allRows[i];
                    if (!row.className.match('nouse') && !row.className.match('sectiontable-printheaderrow')) {
                        rows.push(row);
                    }
                }

                if ( rowlimit < rows.length ) {
                    var height = 0;
                    for( var z=0; z < rowlimit; z++ ) {
                        height = height + rows[z].offsetHeight;
                    }
                    //offsetHeight is returning different values between IE7 and IE8.  mainly for vitals section.
                    //To get around, use the lesser of ht or first row ht * rowlimit
                    var estimatedHeight = rows[0].offsetHeight * rowlimit;
                    if(height < estimatedHeight){
                        table.style.height = height + "px";
                    }else{
                        table.style.height = estimatedHeight + "px";
                    }
                }
                if (y==1) {
                    tables[0].parentNode.style.display='block';
                    tables[1].parentNode.style.display='none';
                }
            }
        }
    }

  /* get all elements with class 'scrollRoot' */
  var scrollRootArray = getElementsByClassName('scrollRoot');
  var scrollRootIdArray =  new Array();
  /* iterate over it and get all elements with id starting with 'labs-results'*/

  for(var i = 0; i < scrollRootArray.length; i++){
    var re = new RegExp("labs[-\w]*[-\w]*");
    var m = re.exec(scrollRootArray[i].id);
    if (m != null) {
      scrollRootIdArray.push(scrollRootArray[i].id);
    }
  }
  /* just for labs results section */
  for(var j = 0; j < scrollRootIdArray.length; j++){
  var el=getElementsByClassName('sectiontablediv',document.getElementById(scrollRootIdArray[j]));
    for ( var y=0; y < el.length; y++) {
      rule=el[y].getAttribute('rowlimit');
      if ( rule != null ) {
        el[y].parentNode.style.display='block';
        rule=parseInt(rule);
        var tbl=el[y].getElementsByTagName('tr');
        if ( rule < tbl.length ) {
          var ht=0;
          for( var z=0; z < rule; z++ ) {
            ht=ht+tbl[z].offsetHeight;
          }
          el[y].style.height=ht+"px";
        }
      }
      el[y].parentNode.style.display='none';
    }
  }
  if(document.getElementById('labs-summary') != null)
     labviews("labs","");
  if(document.getElementById('labs-results-summary') != null)
     labviews("labs-results","");
}

function bindFunction(fn) {
  var args = [];
  for (var n = 1; n < arguments.length; n++)
    args.push(arguments[n]);
  return function () { return fn.apply(this, args); };
}

function scrollFc (a, b) {
   a.style.right = b.scrollLeft + "px";
}

function toPrintALL() {
	var printArea = document.getElementById("print-area");

    printArea.innerHTML = '<br/>';
	var arr = getElementsByClassName("wrap_window");
	for(var x=0; x<arr.length;x++) {
		printArea.innerHTML+=arr[x].innerHTML;
		printArea.innerHTML+='<br/>';
	}

	adjustPrintAreaAndPrint();
}

function toPrint(obj) {
    while (!(obj.className == "wrap_window")) {
		 obj = obj.parentNode;
	}

    var printArea = document.getElementById("print-area");
    printArea.innerHTML = '<br/>' + obj.innerHTML;

	adjustPrintAreaAndPrint();
}


function toSingleColumn() {
    document.getElementById("single-column-button").style.display = 'none';
    document.getElementById("double-column-button").style.display = 'block';

    var printArea = document.getElementById("print-area");

    printArea.innerHTML = '<br/>';
    var arr = getElementsByClassName("wrap_window");
    for (var x = 0; x < arr.length; x++) {
        printArea.innerHTML += arr[x].innerHTML;
        printArea.innerHTML += '<br/>';
    }
    var content = document.getElementById('content');
    var printButton = document.getElementById('printall-button');
    var printArea = document.getElementById("print-area");

    content.style.display = 'none';
    //printButton.style.display='none';


    var arr = getElementsByClassName("sectiontablediv", printArea);
    for (var x = 0; x < arr.length; x++) {
        arr[x].style.height = "auto";
        arr[x].style.overflow = "visible";
    }

    arr = getElementsByClassName("but", printArea);
    for (var x = 0; x < arr.length; x++) {
        arr[x].parentNode.removeChild(arr[x]);
    }

    arr = getElementsByClassName("sectiontableheaderrow", printArea);
    for (var x = 0; x < arr.length; x++) {
        arr[x].parentNode.removeChild(arr[x]);
    }

    arr = getElementsByClassName("sectiontable-printheaderrow", printArea);
    for (var x = 0; x < arr.length; x++) {
        arr[x].style.display = "";
    }

    arr = getElementsByClassName("sectiontable", printArea);
    for (var x = 0; x < arr.length; x++) {
        arr[x].width = 600;
    }

}

function toDoubleColumn() {
    document.getElementById("single-column-button").style.display = 'block';
    document.getElementById("double-column-button").style.display = 'none';

    var content = document.getElementById('content');
    var printButton = document.getElementById('printall-button');
    var printArea = document.getElementById("print-area");

    content.style.display = 'block';
    printButton.style.display = 'block';
    printArea.innerHTML = "";

    doResize();
}


function adjustPrintAreaAndPrint() {
    var content = document.getElementById('content');
    var printButton = document.getElementById('printall-button');
    var printArea = document.getElementById("print-area");

    content.style.display='none';
    printButton.style.display='none';


    var arr = getElementsByClassName("sectiontablediv", printArea);
	for (var x=0;x<arr.length;x++) {
		arr[x].style.height="auto";
		arr[x].style.overflow="visible";
	}

	arr = getElementsByClassName("but", printArea);
	for(var x=0; x < arr.length; x++)  {
		arr[x].parentNode.removeChild(arr[x]);
	}

	arr = getElementsByClassName("sectiontableheaderrow", printArea);
	for(var x=0; x < arr.length; x++)  {
		arr[x].parentNode.removeChild(arr[x]);
	}

    arr = getElementsByClassName("sectiontable-printheaderrow", printArea);
    for(var x=0; x < arr.length; x++)  {
        arr[x].style.display="";
    }

    arr =getElementsByClassName("sectiontable", printArea);
    for (var x = 0; x < arr.length; x++) {
        arr[x].width = 600;
    }

    setTimeout("printAndClean()",1250);
}


function printAndClean() {
    window.print();

    var content = document.getElementById('content');
    var printButton = document.getElementById('printall-button');
    var printArea = document.getElementById("print-area");

    content.style.display='block';
	printButton.style.display='block';
	printArea.innerHTML="";

	doResize();
}

function doResize() {
    var width = document.getElementById('width_measure').offsetWidth;
    if (width != lastSize) {
        var toSet = width - 19;

        var array = getElementsByClassName('sectiontable', document.getElementById("content"));

        for ( var i = 0; i < array.length; i++ ) {
            var toSetMinimal = 500;
            var minimal = array[i] .getAttribute('minimal');
            if ( minimal != null ) {
                toSetMinimal = parseInt(minimal);
            }
            if ( toSet < toSetMinimal )  {
                array[i].width = toSetMinimal;
            } else {
                array[i].width = toSet;
            }
        }
        lastSize = width;
    }
}


var winPop;
function OpenWindow(data){
    winPop = window.open("","winPop",'menubar=1,scrollbars=yes');  // fixed
    sendToChild(data);
}

function OpenWindowUrl(data){
    winPop = window.open(data,"winPop",'menubar=1,scrollbars=yes');  // fixed
}

function sendToChild(data){

    var doc = winPop.document;
    var content = getTextContent(document.getElementById(data));

    doc.open("text/html");
    doc.write('<html><head><title>'+document.getElementById("name_title_"+data).firstChild.nodeValue+'</title>' + '</head><body>' + content + '</body></html>');
    doc.close();
}

function OpenWindow2(data){
    winPop = window.open("","winPop",'menubar=1,scrollbars=yes');  // fixed
    sendToChild2(data);
}

function sendToChild2(data){

    var doc = winPop.document;
    var content = getTextContent(document.getElementById(data));

    doc.open("text/html");
    doc.write(content);
    doc.close();
}

function getTextContent(node) {
    var oldEls= node.childNodes;
    var content = "";
    for (var x=0;x<oldEls.length;x++) {
        if(oldEls[x].nodeValue != null) {
            content = content + oldEls[x].nodeValue;
        } else {
            content = content + oldEls[x].innerHTML;
        }
    }
    return content;
}

function getCurrTime() {
    var a_p = "";
    var d = new Date();
    var curr_hour = d.getHours();
    if (curr_hour < 12) { a_p = "AM"; } else { a_p = "PM"; }
    if (curr_hour == 0) { curr_hour = 12; }
    if (curr_hour > 12) { curr_hour = curr_hour - 12; }

    var curr_min = d.getMinutes();
    curr_min = curr_min + "";
    if (curr_min.length == 1) { curr_min = "0" + curr_min; }
    return (curr_hour + ":" + curr_min + " " + a_p);
}

function initSortableTables() {
   var tables = getElementsByClassName('sortable');
   for (var i = 0; i < tables.length; i++) {
      if (tables[i].id != "") {
        var t = new SortableTable(tables[i]);
      }
   }
}


function SortableTable (tableEl) {
   //  alert(tableEl.id);
  this.tbody = tableEl.getElementsByTagName('tbody');
	this.thead = document.getElementById(tableEl.id + '_header').getElementsByTagName('tbody');
	this.tfoot = tableEl.getElementsByTagName('tfoot');

	this.getInnerText = function (el) {
		if (typeof(el.textContent) != 'undefined') return el.textContent;
		if (typeof(el.innerText) != 'undefined') return el.innerText;
		if (typeof(el.innerHTML) == 'string') return el.innerHTML.replace(/<[^<>]+>/g,'');
	};

	this.getParent = function (el, pTagName) {
		if (el == null) return null;
		else if (el.nodeType == 1 && el.tagName.toLowerCase() == pTagName.toLowerCase())
			return el;
		else
			return this.getParent(el.parentNode, pTagName);
	};

	this.sort = function (cell) {

	  var column = cell.cellIndex;
	  var itm = this.getInnerText(this.tbody[0].rows[0].cells[column]);
		var sortfn = this.sortCaseInsensitive;

		if (itm.match(/\d\d[/]+\d\d[/]+\d\d\d\d/)) sortfn = this.sortDate; /* date format mm-dd-yyyy */
		if (itm.replace(/^\s+|\s+$/g,"").match(/^[\d\.]+$/)) sortfn = this.sortNumeric;

		this.sortColumnIndex = column;

		var newRows = new Array();

	    for (var j = 0; j < this.tbody[0].rows.length; j++) {
          newRows[j] = this.tbody[0].rows[j];
        }

		newRows.sort(sortfn);

		if (cell.getAttribute("sortdir") == 'down') {
			newRows.reverse();
			cell.setAttribute('sortdir','up');
		} else {
			cell.setAttribute('sortdir','down');
		}

		for ( i=0; i<newRows.length; i++) {
			this.tbody[0].appendChild(newRows[i]);
	    }
	};

	this.sortCaseInsensitive = function(a,b) {
	    aa = thisObject.getInnerText(a.cells[thisObject.sortColumnIndex]).toLowerCase();
		bb = thisObject.getInnerText(b.cells[thisObject.sortColumnIndex]).toLowerCase();
		if (aa==bb) return 0;
		if (aa<bb) return -1;
		return 1;
	};

	this.sortDate = function(a,b) {
		aa = thisObject.getInnerText(a.cells[thisObject.sortColumnIndex]);
		bb = thisObject.getInnerText(b.cells[thisObject.sortColumnIndex]);
		date1 = aa.substr(6,4)+aa.substr(3,2)+aa.substr(0,2);
		date2 = bb.substr(6,4)+bb.substr(3,2)+bb.substr(0,2);
		if (date1==date2) return 0;
		if (date1<date2) return -1;
		return 1;
	};

	this.sortNumeric = function(a,b) {
		aa = parseFloat(thisObject.getInnerText(a.cells[thisObject.sortColumnIndex]));
		if (isNaN(aa)) aa = 0;
		bb = parseFloat(thisObject.getInnerText(b.cells[thisObject.sortColumnIndex]));
		if (isNaN(bb)) bb = 0;
		return aa-bb;
	};

	/* define variables */
	var thisObject = this;
	var sortSection = this.thead;

	/* constructor actions */
	if (!(this.tbody && this.tbody[0] && this.tbody[0].rows && this.tbody[0].rows.length > 0)) return;

	if (sortSection && sortSection[0].rows && sortSection[0].rows.length > 0) {
		var sortRow = sortSection[0].rows[0];
	} else {
		return;
	}

	for (var i=0; i<sortRow.cells.length; i++) {
		sortRow.cells[i].sTable = this;
		sortRow.cells[i].onclick = function () {
			this.sTable.sort(this);
			return false;
		}
	}

}

function enableTooltips() {

    var h = document.createElement("span");
    h.id = "btc";
    h.setAttribute("id", "btc");
    h.style.position = "absolute";
    document.getElementsByTagName("body")[0].appendChild(h);

    var links = getElementsByClassName("tooltip_link");
    for (var i = 0; i < links.length; i++) {
        prepare(links[i]);
    }
}

function prepare( el ) {
    var list = getElementsByClassName("tooltip", el);
    if ( list.length != 1 ) return;
    var tooltip = list[0];
   /* setOpacity(tooltip); */
    el.tooltip = tooltip;
    el.onmouseover = showTooltip;
    el.onmouseout = hideTooltip;
    el.onmousemove = Locate;

}

function showTooltip(e) {
    this.tooltip.style.display = 'block';
    document.getElementById("btc").appendChild(this.tooltip);
    Locate(e);
}

function hideTooltip(e) {
    this.tooltip.style.display = 'none';
    var d = document.getElementById("btc");
    if (d.childNodes.length > 0) d.removeChild(d.firstChild);
}

function setOpacity(el) {
    el.style.filter = "alpha(opacity:95)";
    el.style.KHTMLOpacity = "0.95";
    el.style.MozOpacity = "0.95";
    el.style.opacity = "0.95";
}

function Locate(e) {
    var posx = 0,posy = 0;
    if (e == null) e = window.event;
    if (e.pageX || e.pageY) {
        posx = e.pageX;
        posy = e.pageY;
    }
    else if (e.clientX || e.clientY) {
        if (document.documentElement.scrollTop) {
            posx = e.clientX + document.documentElement.scrollLeft;
            posy = e.clientY + document.documentElement.scrollTop;
        }
        else {
            posx = e.clientX + document.body.scrollLeft;
            posy = e.clientY + document.body.scrollTop;
        }
    }
    document.getElementById("btc").style.top = (posy ) + "px";
    document.getElementById("btc").style.left = (posx - 100) + "px";
}

function getElementsByClassName(classname, node)  {
    if(!node) node = document.getElementsByTagName("body")[0];
    var a = [];
    var re = new RegExp('\\b' + classname + '\\b');
    var els = node.getElementsByTagName("*");
    for(var i=0,j=els.length; i<j; i++)
        if(re.test(els[i].className))a.push(els[i]);
    return a;
}


function Map()
{
	var keys=[];
	var data=[];
	this.length=
		function ()
		{
			return keys.length;
		};
	this.clear=
		function ()
		{
			keys=[];
			data=[];
		};
	this.length=
		function ()
		{
			return keys.length;
		};
	this.indexOf=
		function (key)
		{
			var x;
			for (x=0;x<keys.length;x++)
			{
				if (keys[x]==key)
					return x;
			}
			return x;
		};
	this.pushData=
		function (key,el)
		{
			if (key!='@nouse')
			{
                                keys.push(key);
                                data[keys.length-1]=new Array()
                                data[keys.length-1].push(el);
				/*var index=this.indexOf(key);
				if (index<keys.length)
					data[index].push(el);
				else
				{
					keys.push(key);
					data[index]=new Array()
					data[index].push(el);
				}*/
			}
		};
	this.getData=
		function (key)
		{
			var index=this.indexOf(key);
			if (index<keys.length)
				return data[index];
			else
				return null;
		};
	this.getKeys=
		function()
		{
			return keys;
		};


	this.sortAscending=
		function()
		{

			for (var i=1; i<keys.length;i++)
			{

				var value=keys[i];
				var valnum=data[i];
				var j=i-1;

				var current=keys[i];
				if (current.match("[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
					current=current.substr(6,4)+current;
				else if (current.match("[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
					current=current.substr(3,4)+current;
				if (current=="")
					current="zzzzzzz";




				var done=false;
				do
				{
					var next=keys[j];
					if (next.match("[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
						next=next.substr(6,4)+next;
					else if (next.match("[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
						next=next.substr(3,4)+next;
					if (next=="")
						next="zzzzzzz";

					if (next.toLowerCase()>current.toLowerCase())
					{
						keys[j+1]=keys[j];
						data[j+1]=data[j];
						j-=1;
						if (j<0) done=true;
					}
					else done=true;
				} while (!done);

				keys[j+1]=value;
				data[j+1]=valnum;
			}

		};

	this.sortDecending=
		function()
		{

			for (var i=1; i<keys.length;i++)
			{

				var value=keys[i];
				var valnum=data[i];
				var j=i-1;

				var current=keys[i];
				if (current.match("[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
					current=current.substr(6,4)+current;
				if (current.match("[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
					current=current.substr(3,4)+current;
				if (current=="")
					current="!!!!!!!";





				var done=false;
				do
				{
					var next=keys[j];
					if (next.match("[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
						next=next.substr(6,4)+next;
					else if (next.match("[0-9][0-9]/[0-9][0-9][0-9][0-9]"))
						next=next.substr(3,4)+next;
					if (next=="")
						next="!!!!!!!";

					if (next.toLowerCase()<current.toLowerCase())
					{
						keys[j+1]=keys[j];
						data[j+1]=data[j];
						j-=1;
						if (j<0) done=true;
					}
					else done=true;
				} while (!done);

				keys[j+1]=value;
				data[j+1]=valnum;
			}

		};




}

function TableRef(table)
{
	if (table.tagName!="TABLE")
	{
		window.status="TableRef(table):table must be a table, passed:"+table.tagName;
		table=null;
	}

	this.table=table;
	this.rows=(table!=null)?table.rows:null;




	var newEls=[];
	this.pushElements=
		function(els)
		{
			for (var x=0;x<els.length;x++)
			{
				newEls.push(els[x]);
			}
		};
	this.pushElement=
		function (el)
		{
			newEls.push(el);
		};

	this.putTable=
		function ()
		{
			if (table==null)
			{
				window.status="putTable():table not found";
				return;
			}



			var oldEls=table.childNodes;
			for (var x=0;x<oldEls.length;x++)
			{
				table.removeChild(oldEls[x]);
			}


			for (var x=0;x<newEls.length;x++)
			{
					if (newEls[x].tagName=='TBODY' || newEls[x].tagName=='TFOOT' || newEls[x].tagName=='THEAD')
					{
						table.appendChild(newEls[x]);
					}
					else if (newEls[x].tagName=='TR')
					{
						var el=document.createElement('tbody');
						while (x<newEls.length && newEls[x].tagName=='TR')
						{
							el.appendChild(newEls[x]);
							x++;
						}
						table.appendChild(el);
					}
					else if (newEls[x].tagName='TD')
					{
						var elparent=document.createElement('tbody');
						var el=document.createElement('tr');
						while (x<newEls.length && newEls[x].tagName=='TR')
						{
							el.appendChild(newEls[x]);
							x++;
						}
						elparent.appendChild(el);
						table.appendChild(elparent);
					}

			}
		};

	this.cols=
		function ()
		{
			if (table==null)
			{
				window.status="cols():table not found";
				return null;
			}
			return table.childNodes[0].childNodes[0].childNodes.length;
		};

	this.col=
		function (num)
		{
			if (table==null)
			{
				window.status="TableRef.row():table not found";
				return;
			}
			return table.childNodes[0].childNodes[0].childNodes[num].cloneNode(true);
		};
	this.rows=
		function()
		{
			if (table==null)
			{
				window.status="rows():table not found";
				return null;
			}
			return table.childNodes[0].childNodes.length;
		};
	this.row=
		function (num)
		{
			if (table==null)
			{
				window.status="TableRef.row():table not found";
				return;
			}
			return table.childNodes[0].childNodes[num].cloneNode(true);
		};
	this.colData=
		function (num)
		{
			if (table==null)
			{
				window.status="TableRef.colData():table not found";
				return null;
			}

			var dat=[];
			var bdy=table.rows;


			for (var x=0;x<bdy.length;x++)
			{
				var str;
				var el=bdy[x].childNodes[num];



				if (el==null || el.parentNode.className.match('nouse'))
					str='@nouse';
				else
				{
					str=el.innerHTML;
					while (str.charAt(0).match('<'))
					{
						el=el.childNodes[0];
						if (el==null)
						{
							str=' ';
							break;
						}
						str=el.innerHTML;
					}
				}

				dat.push(str);
			}
			return dat;
		};
}


function addCurrentTimeToBanner() {
    var el = document.getElementById("banner-current-time");
    if (el != null) {
        el.innerHTML = getCurrTime();
    }
}

window.onload = onLoad;
window.onresize = doResize;

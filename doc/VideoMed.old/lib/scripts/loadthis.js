//Load category buttons
		$.getJSON('json/categories.json', function(gData) {
			//alert("Group: " + gData.groups[0].name);
			//var select = document.getElementById("dBoxCategories");
			//var html = '';
			for (var i in gData.groups) {
				//html += '<option value="' + data.groups[i].path + '">' + data.groups[i].name + '</option>';
				//select.options[select.options.length] = new Option(gData.groups[i].name, gData.groups[i].path);
				//alert(gData.groups[i].fn);
				var bn = 'Button'+i;
				makeButton(gData.groups[i].name, bn, gData.groups[i].fn);
				}
			//$('select.dBoxCategories').append(html);
		});
//Makes a Category Button element
		function makeButton(name, bn, fn){
				var bl = document.getElementById('buttonlist');
				var element = document.createElement('input');
				element.setAttribute('type', 'button');
				element.setAttribute('value', name);
				element.setAttribute('id', bn);
				element.setAttribute('class', 'button');
				element.setAttribute('onclick', 'makeVideoList('+"'"+fn+"'"+');');
				bl.appendChild(element);
		};
//Makes a list of video file when the category button is clicked
		function makeVideoList(value){
			document.getElementById("videolist").innerHTML = "";
			$.getJSON(value, function(pData) {
			var output="<dl>";
			for (var i in pData.videos) {
				//alert(pData.videos[i].title);
				var id =pData.videos[i].id;
				var link =pData.videos[i].link
				output+="<dt><input type=button class=plusbutton onclick=addToPlayList("+ id +", '" + link  + "') value=+><data value="+ pData.videos[i].link + "></data></input>";
				output+= pData.videos[i].title +"...Run Time: " + pData.videos[i].runtime+"</dt>";
			}
			output+="</dl>";
			document.getElementById("videolist").innerHTML=output;
			})
		};
//Makes the Add video button
		function addToPlayListButton(id){
			var element = document.createElement('input');
				element.setAttribute('type', 'button');
				element.setAttribute('value', '+');
				element.setAttribute('id', id);
				element.setAttribute('class', 'plusbutton');
				element.setAttribute('onclick', 'addToPlayList('+"'"+id+"'"+');');
		}	
//Add vidoe to playlist
		function addToPlayList(id, link){
			alert(link);
		};
		
		
//Load videos titles
		/*$.getJSON('json/acne.json', function(data) {
			var output="<ul>";
			for (var i in data.videos) {
				output+="<li>" + data.videos[i].title + "...Run Time: " + data.videos[i].runtime+"</li>";
			}
			output+="</ul>";
			document.getElementById("placeholder").innerHTML=output;
		});*/
		
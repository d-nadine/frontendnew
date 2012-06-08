self.addEventListener('message', function(e){ 
		try {
	         
			var xhr=new XMLHttpRequest();
	       
      for(var i = 0; i < e.data.urls.length;i++){
        xhr.open('GET', e.data.urls[i], true);
        xhr.setRequestHeader("X-Radium-User-API-Key", e.data.key);
        xhr.setRequestHeader('content-type', 'application/json');
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send(null);
        xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                  if (xhr.status == 200 || xhr.status ==0) {
                    postMessage(xhr.responseText);
                  } else {
                    throw  xhr.status + xhr.responseText;
                  }
                }
        };
      } 
		} catch (e) {
		    postMessage("ERROR:"+e.message);
			
		}
}, false);

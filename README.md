# titanium_module_tiwechat_android
* 微信登陆及分享的titanium module for ios
* 作者刘明星

本模块实现了微信登陆及分享（好友和朋友圈）功能。调用方式：
```javascript
  var tiwechat = require('com.mamashai.tiwechat');
	if (tiwechat.isWeixinInstalled() == "yes"){
		add_btn("/images/login/weixin", "微信", function(e){
			tiwechat.exampleProp = wechat_key;           //wechat_key是在微信开发者账号注册一个app后返回的值
			tiwechat.loginWeixin(user_id);               //如果已经登陆，只需要绑定，可传入一个已有的user_id
		});
	}

 function ios_resumed(e){
		var url = '';
		if (Ti.App.is_android){
			url = Ti.App.mamashai + "/login_by_weixin/" + user_id + "?key=" + wechat_key + "&code=" + Ti.App.Properties.getString('w_code', '');
		}
		else{
			if (e.url && e.url.indexOf("auth") > 0){
				url = Ti.App.mamashai + "/login_by_weixin/?url=" + encodeURI(e.url);
			}
			else{
				return;
			}
		}
		
		http_call(url, function(e){
					// ......
			});
	}
	Ti.App.addEventListener("ios_resumed", ios_resumed);
	win.addEventListener("close", function(e){
		Ti.App.removeEventListener("ios_resumed", ios_resumed);
	});
	win.addEventListener("focus", function(e){

```

// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import {Socket, LongPoller} from "phoenix"
import $ from "jquery"

class App {

    static notify(){
        if(typeof Notification !== 'undefined'){
            Notification.requestPermission(function (permission) {
                if (permission !== 'granted') return;

                var notification = new Notification('Kind macht Krach', {
                    body: '',
                });

                notification.onclick = function () {
                    window.focus();
                    this.close()
                };
            });
        }
    }

    static init(){

        window.setInterval(function(){
            var d = new Date();
            $('#camera').attr('src', "http://192.168.178.37/html/cam_pic.php?time="+d.getTime()+"&pDelay=200000")
        }, 2000); 

        let socket = new Socket("/socket", {
//            logger: ((kind, msg, data) => { console.log(`${kind}: ${msg}`, data) })
        })

        var files = []
        var $list    = $("#files")

        socket.connect()

        socket.onOpen( ev => console.log("OPEN", ev) )
        socket.onError( ev => console.log("ERROR", ev) )
        socket.onClose( e => console.log("CLOSE", e))

        var chan = socket.channel("room:lobby")
        chan.join().receive("ignore", () => console.log("auth error"))
            .receive("ok", () => console.log("join ok"))
//            .after(10000, () => console.log("Connection interruption"))

        chan.onError(e => console.log("something went wrong", e))
        chan.onClose(e => console.log("channel closed", e))

        chan.on("new:files", msg => {
            var autoplay = $('#flip').checked;
            var alert = false;
            var last = false;
            console.log(msg)
            var f = msg.file;
            if(files.indexOf(f) == -1){
                    files.push(f)
                    alert = true;
                    $list.append('<li><a href="'+f+'">'+f+'</a></li>');
                    last = f;
            }
            if(alert){
                if(autoplay){
                    var audio = new Audio(last);
                    audio.play();
                }
                App.notify();
            }
        })

    }

    static sanitize(html){ return $("<div/>").text(html).html() }
}

App.init()

export default App

module.exports = {
    App: App
};

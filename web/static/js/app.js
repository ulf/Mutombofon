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

    static init(){


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
            var alert = false;
            var last = false;
            msg.files.forEach(function(f){
                f = f.replace('/home/ulf', '');
                if(files.indexOf(f) == -1){
                    files.push(f)
                    alert = true;
                    $list.append('<li><a href="'+f+'">'+f+'</a></li>');
                    last = f;
                }
            })
            if(alert){
                console.log("New Files!");
                var audio = new Audio(last);
                audio.play();
            }
            console.log(msg)
        })

    }

    static sanitize(html){ return $("<div/>").text(html).html() }
}

App.init()

export default App

module.exports = {
    App: App
};

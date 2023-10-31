<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
    <title>Websocket Chat</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- CSS -->
    <link rel="stylesheet" href="/webjars/bootstrap/4.3.1/dist/css/bootstrap.min.css">
<%--    <style>--%>
<%--        [v-cloak] {--%>
<%--            display: none;--%>
<%--        }--%>
<%--    </style>--%>
</head>
<body>
<div class="container" id="app" v-cloak>
    <div class="row">
        <div class="col-md-12">
            <h3>채팅방 리스트</h3>
        </div>
    </div>
    <div class="input-group">
        <div class="input-group-prepend">
            <label class="input-group-text">방제목</label>
        </div>
        <input type="text" class="form-control" name="room_name" value="${room_name}"
<%--               v-on:keyup.enter="createRoom"--%>
        >
        <div class="input-group-append">
            <button class="btn btn-primary" type="button" onclick="createRoom()"
<%--                    @click="createRoom"--%>
            >채팅방 개설</button>
        </div>
    </div>
    <ul class="list-group">
        <li class="list-group-item list-group-item-action"
<%--            v-for="item in chatrooms"--%>
<%--            v-bind:key="item.roomId" v-on:click="enterRoom(item.roomId)"--%>
        >
            {{item.name}}
        </li>
    </ul>
</div>
<!-- JavaScript -->
<script src="/webjars/vue/2.5.16/dist/vue.min.js"></script>
<script src="/webjars/axios/0.17.1/dist/axios.min.js"></script>
<script>
<%--    채팅방 검색 --%>
    $(document).ready(function () {
        findAllRoom();
    })

    function findAllRoom() {
        $.ajax({
            url: "/chat/rooms",
            type: "GET",
            data: {
                room_name : '',
                chatrooms: [
                ]
            },
            success : function (result) {
                result.forEach( el => this.chatrooms = result.data);
            }
        })
    }

    function  createRoom() {
        var room_name = $(".input-group input[name='room_name']").val();
        if("" === room_name) {
            alert("방 제목을 입력해 주십시요.");
            return;
        } else {
            var params = new URLSearchParams();
            params.append("name", room_name);

            $.ajax({
                url: "/chat/room",
                type: "post",
                data: params,
                success : function (result) {
                    alert(result.data.name+"방 개설에 성공하였습니다.")
                    room_name = '';
                    findAllRoom();
                },
                complete : function () {
                    alert("채팅방 개설에 실패하였습니다.");
                }
            });
        }

        // let divElement = document.querySelector('#app')
        // $.ajax({
        //     url: "/chat/rooms",
        //     type: "GET",
        //     data: {
        //         room_name : '',
        //         chatrooms: [
        //         ]
        //     }
        // })
    };

    var vm = new Vue({
        el: '#app',
        data: {
            room_name : '',
            chatrooms: [
            ]
        },
        created() {
            this.findAllRoom();
        },
        methods: {
            findAllRoom: function() {
                axios.get('/chat/rooms').then(response => { this.chatrooms = response.data; });
            },
            createRoom: function() {
                if("" === this.room_name) {
                    alert("방 제목을 입력해 주십시요.");
                    return;
                } else {
                    var params = new URLSearchParams();
                    params.append("name",this.room_name);
                    axios.post('/chat/room', params)
                        .then(
                            response => {
                                alert(response.data.name+"방 개설에 성공하였습니다.")
                                this.room_name = '';
                                this.findAllRoom();
                            }
                        )
                        .catch( response => { alert("채팅방 개설에 실패하였습니다."); } );
                }
            },
            enterRoom: function(roomId) {
                var sender = prompt('대화명을 입력해 주세요.');
                if(sender != "") {
                    localStorage.setItem('wschat.sender',sender);
                    localStorage.setItem('wschat.roomId',roomId);
                    location.href="/chat/room/enter/"+roomId;
                }
            }
        }
    });
</script>
</body>
</html>
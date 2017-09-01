import QtQuick 2.5

Item {
    //mot danh sach cac duong dan hinh anh
    property var listSrc: []
    //toa do cua hinh anh
    property var coorImg: [{x: 0, y: 0}]
    //thoi gian cho cua hinh anh
    property int waitTime: 0
    //thoi gian chuyen dong cua hinh anh
    property int animateTime: 0
    //chieu rong cua hinh anh
    property int imgWid: 100
    //chieu cao cua hinh anh
    property int imgHei: 150
    //kiem tra xem no con dang cho hay khong
    property bool isWait: false
    //xem no co duoc phep chay hay khong
    property bool allowStart: true
    //chi so tung hinh anh chay trong listSrc
    property int ind: 0
    //xoa image di chua
    property bool stateFix: false
    //goc cua static sticker
    property int staticImgAngleSticker: 0
    //
    property bool isAfter: false
    property bool hideImg: false
    property string commentStaticSticker: ""

    Image {
        id: staticImg
        visible: (isAfter == true) ? false : true
        source: (visible== true) ? listSrc[0] : ""
        width: (visible === true)? imgWid : 0
        height: (visible === true) ? imgHei : 0
        x: coorImg[0].x
        y: coorImg[0].y
        NumberAnimation on opacity{
            running: stateFix
            to: 0
            duration: 1000
            onRunningChanged: {
                if(stateFix){
                    staticImg.destroy()
                }
            }
        }
        //dieu chinh xoay theo mot huong nao do ... gia tri dieu chinh la angle
        transform: Rotation { origin.x: 30; origin.y: 30; axis { x: 0; y: 1; z: 0 } angle: staticImgAngleSticker}
    }
    //-------------------------------------------
    Rectangle{
        id: commentStick
        visible: (staticImg.visible) ? true : false
        x: staticImg.x
        y: staticImg.y - height
        property string text
        text: commentStaticSticker
        color: "lightblue"
        NumberAnimation on opacity{
            running: stateFix
            to: 0
            duration: 1000
            onRunningChanged: {
                if(stateFix){
                    commentStick.destroy()
                }
            }
        }
        Text{
            id: text_field
            anchors{top: parent.top; left: parent.left}
            height: parent.height
            width: parent.width
            text: parent.text
            wrapMode: Text.WordWrap
        }
        Text{
            id: dummy_text
            text: parent.text
            visible: false
        }
        states:[
            State{
                name: "wide text"
                when: commentStick.text.length > 20
                PropertyChanges{
                    target: commentStick
                    width: roots.width/6
                    height: text_field.paintedHeight
                }
            },
            State{
                name: "not wide text"
                when: commentStick.text.length <= 20
                PropertyChanges{
                    target: commentStick
                    width: dummy_text.paintedWidth
                    height: dummy_text.paintedHeight
                }
            }

        ]
    }
    //
    Timer{
        id: hideStaticStickerAfter
        interval: waitTime
        running: true
        onTriggered: {
            if(isAfter == true) staticImg.visible = true
        }
    }

    //Xu ly thoi gian cho
    Timer{
        id: waitTimer
        interval: waitTime
        repeat: false
        running: true
        onTriggered: {
            isWait = true
            running = false
        }
    }

    //xu ly hieu ung chuyen dong cho hinh anh
    Timer{
        id: staticAnimate
        interval: 100
        running: allowStart ? isWait : !isWait
        repeat: allowStart ? isWait : !isWait
        onTriggered: {
            if(stateFix) stop()
            else{
                if(ind < listSrc.length){
                    staticImg.source = listSrc[ind]
                    ind++
                }else ind = 0
            }
        }
    }
    Timer{
        interval: animateTime+waitTime
        repeat: false
        running: true
        onTriggered: {
//            staticAnimate.running = false
            allowStart = false
            if(hideImg) staticImg.visible = false
            running = false
        }
    }
}

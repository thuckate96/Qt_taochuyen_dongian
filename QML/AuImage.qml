import QtQuick 2.5

Item {
    //danh sach cac source image
    property var listSrc: []
    //mang toa do ma image di chuyen toi
    property var coorsMove: [{x: 0, y: 0}]
    //mang luu tru toa do cua Image khi chua di chuyen
    property var coorsImg: [{x: 0, y:0}]
    //thoi gian cho de di chuyen cua hinh anh
    property int waitTime: 0
    //thoi gian de hinh anh di toi dich
    property int animateTime: 0
    //chieu rong cua hinh anh
    property int imgWid: 100
    //chieu cao cua hinh anh
    property int imgHei: 150
    //set xem no con dang la thoi gian cho hay khong
    property bool isWait: false
    //xet xem no duoc phep chay chua
    property bool allowStart: true
    //chi so chay tung anh trong danh sach cac hinh anh listSrc
    property int ind: 0
    //toa do x cua image
    property int xImg: 0
    //toa do y cua image
    property int yImg: 0
    //dung de the hien trang thai Img co bi an di hay khong
    property bool hideImg: false
    property bool stateFix: false
    //true the hien no se dung sau mot sticker con false the hien no la mot sticker rieng
    property bool isAfter: false
    //la trang thai cua sticker quay theo huong cua nguoi dung
    property int angleSticker: 0
    property string commentSticker: ""
    Image {
        id: image
        visible: (isAfter == true) ? false : true
        x: coorsImg[0].x
        y: coorsImg[0].y
        source: (visible == true) ? listSrc[0] : ""
        width: (visible === true )?imgWid : 0
        height: (visible === true) ? imgHei : 0
        NumberAnimation on opacity{
            running: stateFix
            to: 0
            duration: 1000
            onRunningChanged: {
                if(stateFix){
                    image.destroy()
                }
            }
        }
        //dieu chinh xoay theo mot huong nao do ... gia tri dieu chinh la angle
        transform: Rotation { origin.x: 30; origin.y: 30; axis { x: 0; y: 1; z: 0 } angle: angleSticker }

    }

    //-------------------------------------------
    Rectangle{
        id: commentStick
        visible: (image.visible) ? true : false
        x: image.x
        y: image.y - height
        property string text
        text: commentSticker
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

    //animate cho viec di chuyen toi mot toa do khac
    ParallelAnimation{
        running: isWait
        NumberAnimation{
            target: image ; property: "x"; to: coorsMove[0].x;
            duration: animateTime; easing.type: Easing.Linear
        }
        NumberAnimation{
            target: image ; property: "y"; to: coorsMove[0].y;
            duration: animateTime; easing.type: Easing.Linear
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
            if(stateFix) stop()
        }
    }
    //Xu ly viec an sticker
    Timer{
        id: hideStickerAfter
        interval: waitTime
        running: true
        onTriggered: {
            if(isAfter == true) image.visible = true
            if(stateFix) stop()
        }
    }
    //Xu ly viec tao chuyen dong cua cac sticker
    Timer{
        id: animate
        interval: animateTime/30
        running: allowStart ? isWait : !isWait
        repeat: allowStart ? isWait : !isWait
        onTriggered: {
            if(stateFix) stop()
            else{
                if(ind < listSrc.length){
                    image.source = listSrc[ind]
                    ind++
                }else ind = 0
                if((image.x===coorsMove[0].x)&&(image.y === coorsMove[0].y)) {
                    allowStart = false
                    if(hideImg) image.visible = false
                    else image.visible = true
                }
            }
        }
    }
}

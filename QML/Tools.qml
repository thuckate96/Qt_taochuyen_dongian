import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
Item {
    property bool toolVisible: false
    property bool arrowVisislbe: false
    property int myVar: 0
    property int waitUpdate: 0
    property int animateUpdate: 0
    property int angleSticker: 0
    //bien kiem tra xem co phai sticker chon tiep theo la chuyen dong hay khong
    property int isMove: 0
    property bool toolCommentSticker: false
    property int yValue: colTolVisible.height+20;
    property int xValue: roots.width/3
    Column{
        id: colTolVisible
        visible: toolVisible
        x: 530
        y: 0
        Row{
            id: rowVals
            Column{
                Text {text: "Wait Time"}
                SpinBox{
                    id: spinWait ;
                    maximumValue: 1000000000;
                    minimumValue: -1000000000;
                    value: (stickerModels.get(index).waitTime === 0) ? 1000 : stickerModels.get(index).waitTime
                }
            }
            Column{
                Text {text: "Animate Time"}
                SpinBox{
                    id: spinAnimate;
                    maximumValue: 1000000000;
                    minimumValue: 0;
                    value: (stickerModels.get(index).animateTime === 0) ? 3000 : stickerModels.get(index).animateTime
                }
            }
            Column{
                Text{text: "Move To"}
                Image{
                    id: moveTo
                    width: 30
                    height: 20
                    source: "../images/arrow.png"

                    MouseArea{
                        id: clickArrow
                        anchors.fill: parent
                        onClicked: {
                            arrowVisislbe = !arrowVisislbe
                        }
                    }
                }
            }
            Column{
                Image {
                    id: name
                    width: 40
                    height: 40
                    source: "../images/Rotate_right.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            angleSticker += 5
                        }
                    }
                }
            }
            Column{
                Image {
                    id: rotateLeft
                    width: 40
                    height: 40
                    source: "../images/Rotate_left.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            angleSticker -= 5
                        }
                    }
                }
            }
            Column{
                Image{
                    id: settingSticker
                    width: 60
                    height: 40
                    source: "../images/setting.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            menuSettingSticker.popup()
                        }
                    }
                }
            }

            Column{
                y: rowVals.height/2

                Button{
                    text: "Update"
                    onClicked: {
//                        myVar = mySticker.xSticker
                        up8Dialog.open()
                    }
                }
            }
            Menu{
                id: menuSettingSticker
                title: "Edit"
                MenuItem {
                    text: "Add comment sticker"
                    onTriggered: {
                        toolCommentSticker = !toolCommentSticker
                    }
                }
                MenuItem{
                    text: "Delete sticker"
                    onTriggered: {
                        console.log(index)
                    }
                }
            }

        }

        //---------------------------------------------------------------------------------------------------------

    }
    Column{

        visible: toolCommentSticker
        y: yValue
        x: xValue

        Text{
            id: deleTxtArea; text:"X"; color: "#333"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    toolCommentSticker = false
                }
            }
        }
        Row{

            TextArea {
                id: txtArea
                style: TextAreaStyle {
                    textColor: "#333"
                    selectionColor: "steelblue"
                    selectedTextColor: "#eee"
                    backgroundColor: "#eee"
                }
                width: roots.width/4

            }

            Button{

                id: clickAddContent
                text: "Enter"
                onClicked: {
                    stickerModels.set(index, {commentSticker: txtArea.text})
                    toolCommentSticker = false
                    txtArea.text= ""
                }
            }
        }
    }
    Dialog{
        id: up8Dialog
        title: "Update data"
        standardButtons: StandardButton.Save | StandardButton.Cancel
        onAccepted: {
            var coorsImg = [{x: mySticker.xSticker, y: mySticker.ySticker}]
            var coorsMove = [{x: arrow.x, y: arrow.y}]
            stickerModels.set(index,{
                                  waitTime: spinWait.value,
                                  animateTime: spinAnimate.value,
                                  coorsMove: coorsMove,
                                  coorsImg: coorsImg,
                                  angleSticker: angleSticker
                              })
        }

    }

    Image {
        id: arrow
        visible: arrowVisislbe
        width: (!arrowVisislbe) ? 0 : 30
        height: (!arrowVisislbe) ? 0 : 20
        x: rowVals.width
        y: moveTo.y + rowVals.height
        source: "../images/arrow.png"
        Drag.active: clicked.drag.active
        Drag.hotSpot.x: arrow.x
        Drag.hotSpot.y: arrow.y
        MouseArea{
            id: clicked
            anchors.fill: parent
            drag.target: parent
            onClicked: {
                moveChoice.open()
//                stickerAfterDialog.open()
                console.log(currentPage)
            }
        }
    }
    Dialog{
        id: moveChoice
        title: "animate"

        Rectangle{
            id: rect1
            width: 100
            height: 40
            Image {
                id: moveSticker
                source: "../images/sticker.png"
                width: 40
                height: rect1.height


            }
            MouseArea{
                id: moveStickerClicked
                anchors.fill: parent
                onClicked: {
                    rect1.color = "lightblue"
                    rect2.color = "white"
                    isMove = 1
                }
            }
        }
        Rectangle{
            anchors.top: rect1.bottom
            id: rect2
            width: rect1.width
            height: rect1.height
            Image {
                id: staticChoice
                source: "../images/static_sticker.png"
                width: moveSticker.width
                height: moveSticker.height
            }
            MouseArea{
                id: staticChoiceClicked
                anchors.fill: parent
                onClicked: {
                    rect1.color = "white"
                    rect2.color = "lightblue"
                    isMove = 2
                }
            }
        }

        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            if(isMove ==1){
                stickerAfterDialog.open()
            }else if(isMove == 2){
                staticStickerAfterDialog.open()
            }
        }
    }
    //Mo va chon file sticker dung sau mot sticker khac
    FileDialog{
        id: stickerAfterDialog
        nameFilters: ["*.png", "*.jpg", "All file(*)"]
        folder: shortcuts.music+"/bibi_data/characters/thumbnail"
        selectMultiple: moveStickerClicked.acceptedButtons
        onAccepted: {
            var arrUrls = [], listUrls = []
            arrUrls = stickerAfterDialog.fileUrls
            for(var i = 0; i < arrUrls.length; i++){
                listUrls.push({src: arrUrls[i]})
            }
            var CoorsImg = [{x: arrow.x, y: arrow.y}]
            var myWaitTime = stickerModels.get(index).waitTime + stickerModels.get(index).animateTime
            stickerModels.append({
                srcSticker: listUrls,
                coorsImg: CoorsImg,
                coorsMove: CoorsImg,
                waitTime: myWaitTime,
                animateTime: 0,
                hideImg: false,
                visibleTools: false,
                isAfter: true,
                angleSticker: 0,
                pageNum: currentPage,
                commentSticker: ""
             })

            stickerModels.set(index, {hideImg: true})
        }
    }
    //Mo va chon file sticker tinh dung sau mot sticker khac
    FileDialog{
        id: staticStickerAfterDialog
        nameFilters: ["*.png", "*.jpg", "All file(*)"]
        folder: shortcuts.music+"/bibi_data/characters/thumbnail"
        selectMultiple: staticChoiceClicked.acceptedButtons

        onAccepted: {
            var arrUrls = [], listUrls = []
            arrUrls = staticStickerAfterDialog.fileUrls
            for(var i = 0; i < arrUrls.length; i++){
                listUrls.push({src: arrUrls[i]})
            }
            var CoorsImg = [{x: arrow.x, y: arrow.y}]
            var myWaitTime = stickerModels.get(index).waitTime + stickerModels.get(index).animateTime
            statictModels.append({
                SrcStatic: listUrls,
                CoorStaticImg: CoorsImg,
                StaticImgWaitTime: myWaitTime,
                StaticImgAnimateTime: 3000,
                StaticImgHide: false,
                StaticImgisAfter: true,
                StaticImgAngleSticker: 0,
                StaticVisibleTool: false,
                pageNum: currentPage,
                commentStaticSticker: ""
              })
            stickerModels.set(index, {hideImg: true});
        }
    }
}

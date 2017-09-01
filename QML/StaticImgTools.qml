import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
Item {
    property bool staticToolVisible: false
    property int angleSticker: 0
    property bool toolCommentStaticSticker: false
    property int yValue: colTolStaticVisible.height+20;
    property int xValue: roots.width/3
    Column{
        id: colTolStaticVisible
        visible: staticToolVisible

        x: 530
        y: 0
        Row{
            Column{
                Text{text: "WaitTime"}
                SpinBox{
                    id: staticWaitSpinbox
                    maximumValue: 1000000000
                    minimumValue: 0
                    value: (statictModels.get(index).StaticImgWaitTime === 0) ? 1000 : statictModels.get(index).StaticImgWaitTime
                }
            }
            Column{
                Text{text: "AnimateTime"}
                SpinBox{
                    id: staticAnimateSpinbox
                    maximumValue: 1000000000
                    minimumValue: 0
                    value: 3000
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
            Image{
                id: stickerAfter
                width: 40
                height: 40
                source: "../images/sticker.png"
                MouseArea{
                    id: stickerSelectMulti
                    anchors.fill: parent
                    onClicked: {
                        stickerMovingDialog.open()
                        stickerMovingDialog.selectMultiple
                    }
                }
            }
            Image{
                id: staticStickerAfter
                width: 40
                height: 40
                source: "../images/static_sticker.png"
                MouseArea{
                    id: staticSelectMutil
                    anchors.fill: parent
                    onClicked: {
                        stickerStaticDialog.open()
                        stickerStaticDialog.selectMultiple
                    }
                }
            }
            Image{
                id: settingStaticSticker
                width: 60
                height: 40
                source: "../images/setting.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        menuSettingStaticSticker.popup()
                    }
                }
            }
            Menu{
                id: menuSettingStaticSticker
                title: "Edit"
                MenuItem {
                    text: "Add comment sticker"
                    onTriggered: {
                        toolCommentStaticSticker = !toolCommentStaticSticker
                    }
                }
                MenuItem{
                    text: "Delete sticker"
                    onTriggered: {
                        statictModels.remove(index)
                    }
                }
            }
            Button{
                id: btnUpdate
                text: "Update"
                onClicked: {
                    dialogUp8.open()
                }
            }
        }
    }
    Column{

        visible: toolCommentStaticSticker
        y: yValue
        x: xValue

        Text{
            id: deleTxtArea; text:"X"; color: "#333"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    toolCommentStaticSticker = false
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
//                    stickerModels.set(index, {commentSticker: txtArea.text})
                    statictModels.set(index, {commentStaticSticker: txtArea.text})
                    toolCommentStaticSticker = false
                    txtArea.text= ""
                }
            }
        }
    }
    //File dialog cho viec chon file sticker di chuyen
    FileDialog{
        id: stickerMovingDialog
        nameFilters: ["*.png", "*.jpg", "All file(*)"]
        folder: shortcuts.music+"/bibi_data/characters/thumbnail"
        selectMultiple: stickerSelectMulti.acceptedButtons
        onAccepted: {
            var arrUrls = [], listUrls = []
            arrUrls = stickerMovingDialog.fileUrls
            for(var i = 0; i < arrUrls.length; i++){
                listUrls.push({src: arrUrls[i]})
            }
            var coorImg = [{
                    x: statictModels.get(index).CoorStaticImg.get(0).x,
                    y: statictModels.get(index).CoorStaticImg.get(0).y
                 }]
            var myWaitTime = statictModels.get(index).StaticImgWaitTime+statictModels.get(index).StaticImgAnimateTime
            stickerModels.append({
                                     srcSticker: listUrls,
                                     coorsImg: coorImg,
                                     coorsMove: coorImg,
                                     waitTime: myWaitTime,
                                     animateTime: 0,
                                     hideImg: false,
                                     visibleTools: false,
                                     isAfter: true,
                                     angleSticker: 0,
                                     pageNum: currentPage,
                                     commentSticker: ""
                                 })
            statictModels.set(index, {StaticImgHide: true})
        }
    }
    //FileDialog cho viec chon sticker tinh
    FileDialog{
        id: stickerStaticDialog
        nameFilters: ["*.png", "*.jpg", "All file(*)"]
        folder: shortcuts.music+"/bibi_data/characters/thumbnail"
        selectMultiple: staticSelectMutil.acceptedButtons
        onAccepted: {
            var arrUrls = [], listUrls = []
            arrUrls = stickerStaticDialog.fileUrls
            for(var i = 0; i < arrUrls.length; i++){
                listUrls.push({src: arrUrls[i]})
            }
            var coorImg = [{
                    x: statictModels.get(index).CoorStaticImg.get(0).x,
                    y: statictModels.get(index).CoorStaticImg.get(0).y
                 }]
            var myWaitTime = statictModels.get(index).StaticImgWaitTime+statictModels.get(index).StaticImgAnimateTime

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
            statictModels.set(index, {StaticImgHide: true})
        }
    }

    Dialog{
        id: dialogUp8
        title: "update"
        standardButtons: StandardButton.Save | StandardButton.Cancel
        onAccepted: {
//            console.log(staticsticker.xStaticImg)
            var CoorStaticImg = [{x: staticsticker.xStaticImg, y: staticsticker.yStaticImg}]
            statictModels.set(index, {
                CoorStaticImg: CoorStaticImg,
                StaticImgWaitTime: staticWaitSpinbox.value,
                StaticImgAnimateTime: staticAnimateSpinbox.value,
                StaticImgAngleSticker: angleSticker
            })
        }
    }
}

import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../Js/ConfixTools.js" as ConfT
import "../Js/CreateImage.js" as CreImage
import "../Js/StaticImgCom.js" as CreStaticImg
Item {
    property int currentPage: 1
    property int numOfPages: 1
    property bool isStart: false
    property bool isStartSingle: false
    property int xDefault: roots.width/2
    property int yDefault: roots.height/2
    property bool stateFix: false
    property bool toolContentPage: false
    Rectangle{
        //Models luu tru Background cua tung page
        ListModel{
            id: bgModels
            ListElement{
                page: 1
                srcImg: "../images/bgDefault.png"
                contentPage: ""
            }
        }
        //Models Luu tru sticker
        ListModel{
            id: stickerModels
            ListElement{
                srcSticker: [ListElement{src: ""}]
                coorsMove: [ListElement{x: 0; y: 0}]
                coorsImg: [ListElement{x: 0; y: 0}]
                waitTime: 0
                animateTime: 0
                hideImg: false
                visibleTools: false
                isAfter: false
                angleSticker: 0
                pageNum: 0
                commentSticker: ""
            }
        }
        //Models cua sticker khong the di chuyen
        ListModel{
            id: statictModels
            ListElement{
                SrcStatic: [ListElement{src: ""}]
                CoorStaticImg: [ListElement{x: 0; y: 0}]
                StaticImgWaitTime: 0
                StaticImgAnimateTime: 0
                StaticImgHide: false
                StaticImgisAfter: false
                StaticImgAngleSticker: 0
                StaticVisibleTool: false
                pageNum: 0
                commentStaticSticker: ""
            }
        }

        //Mo file de chon back ground
        FileDialog{
            id: bgDialog
            nameFilters: ["*.png", "*.jpg", "All file(*)"]
            folder: shortcuts.music+"/bibi_data/characters/thumbnail"
            onAccepted: {

                var check = 0, index = 0;
                for(var i = 0; i < bgModels.count; i++){
                    if(bgModels.get(i).page === currentPage){check = 1; index = i; break}
                }
                if(check ==1) bgModels.set(index, {srcImg: ""+bgDialog.fileUrl})
            }
        }
        //Mo file de chon Sticker
        FileDialog{
            id: stickerDialog
            nameFilters: ["*.png", "*.jpg", "All file(*)"]
            folder: shortcuts.music+"/bibi_data/characters/thumbnail"
            selectMultiple: clickStick.acceptedButtons
            onAccepted: {
                isChooseSticker()
            }
        }
        //------------------------- lua chon static sticker ----------------------------------------
        FileDialog{
            id: dialogStatic
            nameFilters: ["*.png", "*.jpg", "All file(*)"]
            folder: shortcuts.music+"/bibi_data/characters/thumbnail"
            selectMultiple: click_static_Sticker.acceptedButtons
            onAccepted: {
                var arrUrls = [], listUrls = []
                arrUrls = dialogStatic.fileUrls
                for(var i = 0; i < arrUrls.length; i++){
                    listUrls.push({src: arrUrls[i]})
                }
                var coorsStaticImg = [{x: xDefault, y: yDefault}]
                statictModels.append({
                    SrcStatic: listUrls,
                    CoorStaticImg: coorsStaticImg,
                    StaticImgWaitTime: 0,
                    StaticImgAnimateTime: 0,
                    StaticImgHide: false,
                    StaticImgisAfter: false,
                    StaticImgAngleSticker: 0,
                    StaticVisibleTool: false,
                    pageNum: currentPage,
                    commentStaticSticker: ""
                })
            }
        }
        Row{
            id: startTools
            //Icon background
            Image {
                id: bgIcon
                source: "../images/bgicon.png"
                width: roots.width/20
                height: roots.height/12
                MouseArea{
                    id: bgArea
                    anchors.fill: parent
                    onClicked: {
                        bgDialog.open()
                    }
                    hoverEnabled: true
                }
            }
            //Icon Sticker
            Image {
                id: stickerIcon
                source: "../images/sticker.png"
                width: bgIcon.width
                height: bgIcon.height

                MouseArea{
                    id: clickStick
                    anchors.fill: parent
                    onClicked: {
                        stickerDialog.open()
                        stickerDialog.selectMultiple
                    }
                    hoverEnabled: true
                }
            }
            //icon static sticker
            Image {
                id: staticStickerIcon
                width: bgIcon.width
                height: bgIcon.height
                source: "../images/static_sticker.png"
                MouseArea{
                    id: click_static_Sticker
                    anchors.fill: parent
                    onClicked: {
                        dialogStatic.open()
                        dialogStatic.selectMultiple
                    }
                    hoverEnabled: true
                }
            }
            //Number of page
            Text{
                id: idPage
                color: "LightSeaGreen"
                y: bgIcon.height/4
                text: "<h2>"+currentPage+"/"+numOfPages +"</h2>"
            }
            //New page
            Image{
                id: newPage
                width: bgIcon.width
                height: bgIcon.height
                source: "../images/new.png"
                MouseArea{
                    id: newPageArea
                    anchors.fill: parent
                    onClicked: {
                        numOfPages++
                        currentPage = numOfPages
                        bgModels.append({
                                            page: numOfPages,
                                            srcImg: "../images/bgDefault.png",
                                            contentPage: ""
                                        })
                    }
                    hoverEnabled: true
                }
            }
            //Icon start and stop all page
            Image{
                id: startStop
                width: bgIcon.width
                height: bgIcon.height
                source: (!isStart) ? "../images/start1.png" : "../images/stop.png"
                MouseArea{
                    id: areaStartAllPage
                    anchors.fill: parent
                    onClicked: {
                        isStart = !isStart

                        if(isStart){
                            viewStickerSetting.visible = false
                            viewStaticStickerSetting.visible = false
                            page.visible = true
                            page.loadAllPage()
                        }else if(!isStart){
                            viewStickerSetting.visible = true
                            viewStaticStickerSetting.visible = true
                            for(var i = 0; i < page.children.length; i++){
                                page.children[i].stateFix = true
                            }
                        }

                        if(isStart == true) isStartSingle = false
                        if(stickerModels.count == 1 && statictModels.count ===1){
                            message.visible = true
                        }else message.visible = false

                        if((stickerModels.count == 1 && !isStart)||(statictModels.count === 1 && !isStart))
                            message.visible = false

                    }
                    hoverEnabled: true
                }
            }
            //Icon start and stop sigle page
            Image{
                id: startStopSinglePage
                width: bgIcon.width
                height: bgIcon.height
                source: (!isStartSingle) ? "../images/play1.png" : "../images/skip-to-start.png"
                MouseArea{
                    id: areaStartSinglePage
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        isStartSingle = !isStartSingle
                        if(isStartSingle){
                            viewStaticStickerSetting.visible = false
                            viewStickerSetting.visible = false
                            page.visible = true
                            page.loadPage()
                            console.log("Current Page: "+currentPage)
                            if(nextBtn.visible == true) nextBtn.visible = false
                            if(previous.visible == true) previous.visible = false
                        }else if(!isStartSingle){
                            if(nextBtn.visible == false) nextBtn.visible = true
                            if(previous.visible == false) previous.visible = true
                            viewStickerSetting.visible = true
                            viewStaticStickerSetting.visible = true
                            for(var i = 0; i < page.children.length; i++){
                                page.children[i].stateFix = true
                            }
                            console.log("page length children "+page.children.length)
                        }
                        if(isStartSingle == true) isStart = false
                        if(stickerModels.count == 1 && statictModels.count ===1){
                            message.visible = true
                        }else message.visible = false

                        if((stickerModels.count == 1 && !isStartSingle)||(statictModels.count === 1 && !isStartSingle))
                            message.visible = false
                    }
                }
            }
            //Icon setting
            Image{
                id: iconSetting
                width: bgIcon.width+5
                height: bgIcon.height
                source: "../images/setting.png"
                MouseArea{
                    id: settingArea
                    anchors.fill: parent
                    onPressed: {
                        menuSetting.popup()
                    }
                    hoverEnabled: true
                }
            }

        }

        //ListView hien thi Background
        ListView{
            anchors.top: startTools.bottom
            id: viewBackGround
            model: bgModels
            delegate: Rectangle{
                Image{
                    source: srcImg
                    width: (currentPage === page) ? roots.width : 0
                    height: (currentPage === page) ? (roots.height-startTools.height) : 0
                }
                Rectangle{
                    id: commentStk
                    visible: (page === currentPage) ? true: false

                    property string text
                    text: contentPage
                    color: "lightblue"

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
                            when: commentStk.text.length > 50
                            PropertyChanges{
                                target: commentStk
                                width: roots.width/3
                                height: text_field.paintedHeight
                            }
                        },
                        State{
                            name: "not wide text"
                            when: commentStk.text.length <= 100
                            PropertyChanges{
                                target: commentStk
                                width: dummy_text.paintedWidth
                                height: dummy_text.paintedHeight
                            }
                        }

                    ]
                    MouseArea{
                        anchors.fill: parent
                        drag.target:  parent
                    }
                }
            }
        }
        //Text hien thi ghi chu "start all page" ne hover vao button start mau do
        Text{
            id: hoverStartAllPage
            visible: areaStartAllPage.containsMouse ? true : false
            y: startStop.height
            x: startStop.x
            text: (visible) ? "Start all page" : ""
        }
        //Text hien thi ghi chu "start single page" neu hover vao button start mau xanh
        Text{
            id: hoverStartSinglePage
            visible: (areaStartSinglePage.containsMouse) ? true : false
            y: startStopSinglePage.height
            x: startStopSinglePage.x
            text: (visible) ? "Start single page" : ""
        }
        //Text hien thi ghi chu "background option"
        Text{
            id: bgOption
            visible: (bgArea.containsMouse) ? true : false
            y: bgIcon.height
            x: bgIcon.x
            text: (visible) ? "Background option" : ""
        }
        //Text hien thi ghi chu "motion sticker" dung de lua chon sticker chuyen dong
        Text{
            id: motionSticker
            visible: (clickStick.containsMouse) ? true : false
            y: stickerIcon.height
            x: stickerIcon.x
            text: (visible) ? "Motion sticker" : ""
        }
        //Text hien thi ghi chu "static sticker lua chon sticker tinh
        Text{
            id: staticStOp
            visible: (click_static_Sticker.containsMouse) ? true : false
            y: bgIcon.height
            x: staticStickerIcon.x
            text: (visible) ? "Static sticker" : ""
        }
        //Text hien thi ghi chu "Setting"
        Text{
            id: settingOp
            visible: (settingArea.containsMouse) ? true : false
            y: bgIcon.height
            x: iconSetting.x
            text: (visible) ? "Setting" : ""
        }
        //Text hien thi ghi chu "create new page" tao page moi
        Text{
            id: newPageOp
            visible: (newPageArea.containsMouse) ? true : false
            y: bgIcon.height
            x: newPage.x
            text: (visible) ? "Create new page" : ""
        }

        //Image button previous quay tro lai trang truoc
        Image {
            id: previous
            visible: (currentPage > 1) ? true : false
            width:  roots.width/22
            height: roots.height/12
            y: roots.height*10/20
            source: "../images/previous.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    (currentPage > 1) ? currentPage-- : currentPage
                }
            }
        }
        //Image button next ... tro toi trang tiep theo
        Image {
            id: nextBtn
            visible: (currentPage < numOfPages) ? true : false
            width: previous.width
            height: previous.height
            y: roots.height*10/20
            x: roots.width*21/22
            source: "../images/next.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    (currentPage < numOfPages) ? currentPage++ : currentPage
                }
            }
        }
        //Menu cho setting
        Rectangle{
            y: bgIcon.height
            x: iconSetting.x
            Column{
                visible: toolContentPage
                Text{
                    id: deleTxtArea; text:"X"; color: "#333"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            toolContentPage = false
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
                        width: roots.width/3
                    }

                    Button{

                        id: clickAddContent
                        text: "Enter"
                        onClicked: {
                            for(var i = 0; i < numOfPages; i++){
                                if(bgModels.get(i).page === currentPage){
                                    bgModels.set(i, {contentPage: txtArea.text})
                                }
                            }

                            toolContentPage = false
                            txtArea.text=""
                        }
                    }
                }
            }

            Menu{
                id: menuSetting
                title: "Edit"
                MenuItem {
                    text: "Add content page"
                    onTriggered: {
                        toolContentPage = !toolContentPage
                    }
                }
                Menu {
                    title: "Delete page"

                    MenuItem {
                        text: "Delete current page"
                    }
                    MenuItem {
                        text: "Delete all page"
                    }
                }
            }
        }
        Text {
            visible: false
            id: message
            x: roots.width/2
            y: roots.height/2
            text: qsTr("Please choose Image")
            color: "red"
        }
        //ListView sticker setting
        ListView{
            id: viewStickerSetting
            model: stickerModels
            delegate: Rectangle{

                Sticker{

                    id: mySticker
                    angleSticker: tools.angleSticker
                    xSticker: ((coorsImg.get(0).x === 0) && (coorsImg.get(0).y ===0)) ? xDefault : coorsImg.get(0).x
                    ySticker: ((coorsImg.get(0).x === 0) && (coorsImg.get(0).y ===0)) ? yDefault : coorsImg.get(0).y
                }
                Tools{
                    id: tools
                    toolVisible: visibleTools
                }
                Rectangle{
                    id: commentStkSetting
                    visible: (pageNum === currentPage) ? true: false
                    x: mySticker.xSticker
                    y: mySticker.ySticker - height
                    property string text
                    text: commentSticker
                    color: "lightblue"

                    Text{
                        id: textField
                        anchors{top: parent.top; left: parent.left}
                        height: parent.height
                        width: parent.width
                        text: parent.text
                        wrapMode: Text.WordWrap
                    }
                    Text{
                        id: dummyText
                        text: parent.text
                        visible: false
                    }
                    states:[
                        State{
                            name: "wide text"
                            when: commentStkSetting.text.length > 20
                            PropertyChanges{
                                target: commentStkSetting
                                width: roots.width/6
                                height: textField.paintedHeight
                            }
                        },
                        State{
                            name: "not wide text"
                            when: commentStkSetting.text.length <= 20
                            PropertyChanges{
                                target: commentStkSetting
                                width: dummyText.paintedWidth
                                height: dummyText.paintedHeight
                            }
                        }

                    ]
                    MouseArea{
                        anchors.fill: parent
                        drag.target: parent
                    }
                 }
            }
        }
        //Chuyen sang phan static sticker
        ListView{
            id: viewStaticStickerSetting
            model: statictModels
            delegate: Rectangle{

                StaticSticker{
                    id: staticsticker
                    xStaticImg: (
                    (CoorStaticImg.get(0).x === 0) && (CoorStaticImg.get(0).y === 0)
                     )?xDefault : CoorStaticImg.get(0).x
                    yStaticImg: (
                    (CoorStaticImg.get(0).x === 0) && (CoorStaticImg.get(0).y === 0)
                     )?yDefault : CoorStaticImg.get(0).y
                    staticImgAngleSticker: staticImgTools.angleSticker
                }
                Rectangle{
                    id: commentStaticStkSetting
                    visible: (pageNum === currentPage) ? true: false
                    x: staticsticker.xStaticImg
                    y: staticsticker.yStaticImg - height
                    property string text
                    text: commentStaticSticker
                    color: "lightblue"

                    Text{
                        id: text_Field
                        anchors{top: parent.top; left: parent.left}
                        height: parent.height
                        width: parent.width
                        text: parent.text
                        wrapMode: Text.WordWrap
                    }
                    Text{
                        id: dummy_Text
                        text: parent.text
                        visible: false
                    }
                    states:[
                        State{
                            name: "wide text"
                            when: commentStaticStkSetting.text.length > 20
                            PropertyChanges{
                                target: commentStaticStkSetting
                                width: roots.width/6
                                height: text_Field.paintedHeight
                            }
                        },
                        State{
                            name: "not wide text"
                            when: commentStaticStkSetting.text.length <= 20
                            PropertyChanges{
                                target: commentStaticStkSetting
                                width: dummy_Text.paintedWidth
                                height: dummy_Text.paintedHeight
                            }
                        }

                    ]
                 }
                StaticImgTools{
                    id: staticImgTools
                    staticToolVisible: StaticVisibleTool
                }
            }
        }
        //View program
        Rectangle{
            id: page
            //du lieu cua sticker chuyen dong
            property var data : []
            property var coorsImg : []
            property var coorsMove : []
            property var waitTime : []
            property var animateTime : []
            property var hideImg: []
            property var isAfter: []
            property var angleSticker: []
            property var pageNumber: []
            property var currentPaging: []
            property var commentStickers: []
            //du lieu cua sticker tinh
            property var static_data: []
            property var static_coorImg: []
            property var static_waitTime: []
            property var static_animateTime: []
            property var static_angle_sticker: []
            property var static_isAfter: []
            property var static_hideImg: []
            property var static_pageNum: []
            property var static_CurrentPage: []
            property var staticCommentStickers: []
//            property int ind: 0
            function loadPage(){
                var ind = 0;

                //Load va thuc hien chay chuong trinh chuyen dong
                for (var i = 0; i < stickerModels.count; i++){
                    if(stickerModels.get(i).pageNum === currentPage){
                        data[ind] = []
                        for(var j = 0; j < stickerModels.get(i).srcSticker.count; j++){
                            data[ind].push(stickerModels.get(i).srcSticker.get(j).src)
                        }
                        coorsImg[ind] = [{x: stickerModels.get(i).coorsImg.get(0).x, y: stickerModels.get(i).coorsImg.get(0).y}]
                        coorsMove[ind] = [{x: stickerModels.get(i).coorsMove.get(0).x, y: stickerModels.get(i).coorsMove.get(0).y}]
                        waitTime[ind] = stickerModels.get(i).waitTime
                        animateTime[ind] = stickerModels.get(i).animateTime
                        hideImg[ind] = stickerModels.get(i).hideImg
                        isAfter[ind] = stickerModels.get(i).isAfter
                        angleSticker[ind] = stickerModels.get(i).angleSticker
                        pageNumber[ind] = stickerModels.get(i).pageNum
                        commentStickers[ind] = stickerModels.get(i).commentSticker
                        ind++
                    }
                }

                for(var i = 0; i < data.length; i++){
                    if(pageNumber[i] === currentPage){
                        CreImage.createImage(
                                    coorsImg[i],
                                    waitTime[i],
                                    data[i],
                                    coorsMove[i],
                                    animateTime[i],
                                    hideImg[i],
                                    isAfter[i],
                                    angleSticker[i],
                                    commentStickers[i]
                        )
                    }
                }

                //---------------------------------------------------------------------------------
                //Load va thuc hien viec chay chuyen dong tai cho
                var indStatic = 0;
                for(var ii = 0; ii < statictModels.count; ii++){

                    if(statictModels.get(ii).pageNum === currentPage){
                        static_data[indStatic] = []
                        for(var jj = 0; jj < statictModels.get(ii).SrcStatic.count ; jj++){
                            static_data[indStatic].push(statictModels.get(ii).SrcStatic.get(jj).src)
                        }
                        static_coorImg[indStatic] = [{
                                                  x: statictModels.get(ii).CoorStaticImg.get(0).x,
                                                  y: statictModels.get(ii).CoorStaticImg.get(0).y
                                              }]
                        static_waitTime[indStatic] = statictModels.get(ii).StaticImgWaitTime
                        static_animateTime[indStatic] = statictModels.get(ii).StaticImgAnimateTime
                        static_angle_sticker[indStatic] = statictModels.get(ii).StaticImgAngleSticker
                        static_isAfter[indStatic] = statictModels.get(ii).StaticImgisAfter
                        static_hideImg[indStatic] = statictModels.get(ii).StaticImgHide
                        static_pageNum[indStatic] = statictModels.get(ii).pageNum
                        staticCommentStickers[indStatic] = statictModels.get(ii).commentStaticSticker
                        indStatic++
                    }

                }
                for(var iii = 0; iii< static_data.length; iii++){
                    if(static_pageNum[iii] === currentPage){
                        CreStaticImg.createImage(
                                    static_data[iii],
                                    static_coorImg[iii],
                                    static_waitTime[iii],
                                    static_animateTime[iii],
                                    static_angle_sticker[iii],
                                    static_isAfter[iii],
                                    static_hideImg[iii],
                                    staticCommentStickers[iii]
                                    )
                    }
                }
            }


            function loadAllPage(){
//                var data=[], coorsImg=[], coorsMove=[], waitTime=[],animateTime=[],hideImg=[], isAfter=[];
//                var angleSticker=[], pageNumber=[] ;
//                for(var i = 1; i <= numOfPages; i++){
//                    data[i] = []
//                    if(stickerModels.count > 1){
//                        for(var j = 0; j < stickerModels.count; j++){

//                            if(stickerModels.get(j).pageNum === i)
//                            {

//                                for(var jj = 0; jj < stickerModels.get(j).srcSticker.count; jj++)
//                                    data[i].push(stickerModels.get(j).srcSticker.get(jj).src)
//                                coorsImg[i] = [{
//                                                   x: stickerModels.get(j).coorsImg.get(0).x,
//                                                   y: stickerModels.get(j).coorsImg.get(0).y
//                                               }]
//                                coorsMove[i] = [{
//                                                    x: stickerModels.get(j).coorsMove.get(0).x,
//                                                    y: stickerModels.get(j).coorsMove.get(0).y
//                                                }]
//                                waitTime[i] = stickerModels.get(j).waitTime
//                                animateTime[i] = stickerModels.get(j).animateTime
//                                hideImg[i] = stickerModels.get(j).hideImg
//                                isAfter[i] = stickerModels.get(j).isAfter
//                                angleSticker[i] = stickerModels.get(j).angleSticker
//                                pageNumber[i] = stickerModels.get(j).pageNum

//                            }

//                        }
//                    }
//                }
//                console.log("Hi")
//                for(var ii = 0; ii < data.length; ii++){

//                    CreImage.createImage(
//                                coorsImg[ii],
//                                waitTime[ii],
//                                data[ii],
//                                coorsMove[ii],
//                                animateTime[ii],
//                                hideImg[ii],
//                                isAfter[ii],
//                                angleSticker[ii]
//                    )
//                }

//                console.log("abc: "+stickerModels.get(1).pageNum)
            }

        }
    }
    //khi chon xong cac sticker

    function isChooseSticker(){
        var arrUrls = [], listUrls = []
        arrUrls = stickerDialog.fileUrls
        for(var i = 0; i < arrUrls.length; i++){
            listUrls.push({src: arrUrls[i]})
        }
        var Coors = [{x: xDefault, y: yDefault}]
        stickerModels.append({
            srcSticker: listUrls,
            coorsImg: Coors,
            coorsMove: Coors,
            waitTime: 0,
            animateTime: 0,
            hideImg: false,
            visibleTools: false,
            isAfter: false,
            angleSticker: 0,
            pageNum: currentPage,
            commentSticker: ""
         })
        message.visible = false
    }
}

import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    property int xStaticImg: 0
    property int yStaticImg: 0
    property int staticImgAngleSticker: 0
    Image{
        id: staticImg
        width: (SrcStatic.get(0).src === "" || (currentPage != pageNum)) ? 0 : 120
        height: (SrcStatic.get(0).src === "" || (currentPage != pageNum)) ? 0 : 150
        source: (currentPage == pageNum) ? SrcStatic.get(0).src : ""
        x: xStaticImg
        y: yStaticImg
        Drag.active: clicked.drag.active
        Drag.hotSpot.x: xStaticImg
        Drag.hotSpot.y: yStaticImg
        transform: Rotation { origin.x: 30; origin.y: 30; axis { x: 0; y: 1; z: 0 } angle: staticImgAngleSticker}
        MouseArea{
            id: clicked
            anchors.fill: parent
            drag.target: parent
            onClicked: {
                for(var i = 0; i < statictModels.count; i++){
                    if(i == index){
                        statictModels.set(i, {StaticVisibleTool: !staticImgTools.staticToolVisible})
                    }else{
                        statictModels.set(i, {StaticVisibleTool: false})
                    }
                }
                for(var j = 0; j < stickerModels.count; j++){
                    if(stickerModels.get(j).visibleTools === true)
                        stickerModels.set(j, {visibleTools: false})
                }
                xStaticImg = staticImg.x
                yStaticImg = staticImg.y
            }
        }
    }
}

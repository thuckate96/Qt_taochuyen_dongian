import QtQuick 2.5
import QtQuick.Controls 1.4
Item {
    property int widSticker: 100
    property int heiSticker: 150
    property int xSticker: 0
    property int ySticker: 0
    property int angleSticker: 0
//    property bool staticStickerClick: false
    Image{
        id: image
        source: (currentPage === pageNum) ? srcSticker.get(0).src : ""
        width: (srcSticker.get(0).src === "" || (currentPage != pageNum)) ? 0 : widSticker
        height: (srcSticker.get(0).src === "" || (currentPage != pageNum)) ? 0 : heiSticker
        x: xSticker
        y: ySticker
        Drag.active: clicked.drag.active
        Drag.hotSpot.x: image.x
        Drag.hotSpot.y: image.y
        transform: Rotation { origin.x: 30; origin.y: 30; axis { x: 0; y: 1; z: 0 } angle: angleSticker}
        MouseArea{
            id: clicked
            anchors.fill: parent
            drag.target: parent
            onClicked: {
                for(var i = 0; i < stickerModels.count; i++){
                    if(i == index) {
                        stickerModels.set(i, {visibleTools: !tools.toolVisible})
                    }
                    else {
                        stickerModels.set(i, {visibleTools: false})
                    }
                }
                //
                for(var j = 0; j < statictModels.count; j++){
                    if(statictModels.get(j).StaticVisibleTool === true)
                        statictModels.set(j, {StaticVisibleTool: false})
                }

                xSticker = image.x
                ySticker = image.y
            }
        }
    }
}

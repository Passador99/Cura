// Copyright (c) 2018 Ultimaker B.V.
// Toolbox is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.4
import UM 1.1 as UM

Item
{
    id: header
    width: parent.width
    height: UM.Theme.getSize("base_unit").height * 4
    Row
    {
        id: bar
        spacing: 12
        height: childrenRect.height
        width: childrenRect.width
        anchors
        {
            left: parent.left
            leftMargin: UM.Theme.getSize("default_margin").width
        }
        ToolboxTabButton
        {
            text: catalog.i18nc("@title:tab", "Plugins")
            active: toolbox.viewCategory == "plugin"
            onClicked:
            {
                toolbox.filterModelByProp("packages", "type", "plugin")
                toolbox.filterModelByProp("authors", "type", "plugin")
                toolbox.viewCategory = "plugin"
                toolbox.viewPage = "overview"
            }
        }
        ToolboxTabButton
        {
            text: catalog.i18nc("@title:tab", "Materials")
            active: toolbox.viewCategory == "material"
            onClicked:
            {
                toolbox.filterModelByProp("packages", "type", "material")
                toolbox.filterModelByProp("authors", "type", "material")
                toolbox.viewCategory = "material"
                toolbox.viewPage = "overview"
            }
        }
    }
    ToolboxTabButton
    {
        text: catalog.i18nc("@title:tab", "Installed")
        active: toolbox.viewCategory == "installed"
        anchors
        {
            right: parent.right
            rightMargin: UM.Theme.getSize("default_margin").width
        }
        onClicked: toolbox.viewCategory = "installed"
    }
    ToolboxShadow
    {
        anchors.top: bar.bottom
    }
}
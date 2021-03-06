// Copyright (c) 2017 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import UM 1.1 as UM
import Cura 1.0 as Cura

Item {
    id: base

    property bool activity: CuraApplication.platformActivity
    property string fileBaseName: PrintInformation.baseName

    UM.I18nCatalog { id: catalog; name:"cura"}

    height: childrenRect.height

    onActivityChanged: {
        if (activity == false) {
            //When there is no mesh in the buildplate; the printJobTextField is set to an empty string so it doesn't set an empty string as a jobName (which is later used for saving the file)
            PrintInformation.baseName = ''
        }
    }

    Rectangle
    {
        id: jobNameRow
        anchors.top: parent.top
        anchors.right: parent.right
        height: UM.Theme.getSize("jobspecs_line").height
        visible: base.activity

        Item
        {
            width: parent.width
            height: parent.height

            Button
            {
                id: printJobPencilIcon
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: UM.Theme.getSize("save_button_specs_icons").width
                height: UM.Theme.getSize("save_button_specs_icons").height

                onClicked:
                {
                    printJobTextfield.selectAll();
                    printJobTextfield.focus = true;
                }
                style: ButtonStyle
                {
                    background: Item
                    {
                        UM.RecolorImage
                        {
                            width: UM.Theme.getSize("save_button_specs_icons").width;
                            height: UM.Theme.getSize("save_button_specs_icons").height;
                            sourceSize.width: width;
                            sourceSize.height: width;
                            color: control.hovered ? UM.Theme.getColor("text_scene_hover") : UM.Theme.getColor("sidebar_lining");
                            source: UM.Theme.getIcon("pencil");
                        }
                    }
                }
            }

            TextField
            {
                id: printJobTextfield
                anchors.right: printJobPencilIcon.left
                anchors.rightMargin: Math.round(UM.Theme.getSize("default_margin").width / 2)
                height: UM.Theme.getSize("jobspecs_line").height
                width: Math.max(__contentWidth + UM.Theme.getSize("default_margin").width, 50)
                maximumLength: 120
                property int unremovableSpacing: 5
                text: PrintInformation.jobName
                horizontalAlignment: TextInput.AlignRight
                onEditingFinished: {
                    var new_name = text == "" ? "unnamed" : text;
                    PrintInformation.setJobName(new_name, true);
                    printJobTextfield.focus = false;
                }
                validator: RegExpValidator {
                    regExp: /^[^\\ \/ \*\?\|\[\]]*$/
                }
                style: TextFieldStyle{
                    textColor: UM.Theme.getColor("sidebar_header_text_inactive");
                    font: UM.Theme.getFont("doppiobis_default_bold");
                    background: Rectangle {
                        opacity: 0
                        border.width: 0
                    }
                }
            }
        }
    }

    Row {
        id: additionalComponentsRow
        anchors.top: jobNameRow.bottom
        anchors.right: parent.right
    }

    Label
    {
        id: boundingSpec
        anchors.top: jobNameRow.bottom
        anchors.right: additionalComponentsRow.left
        anchors.rightMargin:
        {
            if (additionalComponentsRow.width > 0)
            {
                return UM.Theme.getSize("default_margin").width
            }
            else
            {
                return 0;
            }
        }
        height: UM.Theme.getSize("jobspecs_line").height
        verticalAlignment: Text.AlignVCenter
        font: UM.Theme.getFont("small")
        color: UM.Theme.getColor("sidebar_header_text_inactive")
        text: CuraApplication.getSceneBoundingBoxString
    }

    Component.onCompleted: {
        base.addAdditionalComponents("jobSpecsButton")
    }

    Connections {
        target: CuraApplication
        onAdditionalComponentsChanged: base.addAdditionalComponents("jobSpecsButton")
    }

    function addAdditionalComponents (areaId) {
        if(areaId == "jobSpecsButton") {
            for (var component in CuraApplication.additionalComponents["jobSpecsButton"]) {
                CuraApplication.additionalComponents["jobSpecsButton"][component].parent = additionalComponentsRow
            }
        }
    }

}

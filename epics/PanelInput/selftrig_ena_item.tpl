         <item>
          <widget class="caToggleButton" name="catogglebutton_selftrig_<CHANNEL>">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Fixed" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>20</height>
            </size>
           </property>
           <property name="maximumSize">
            <size>
             <width>16777215</width>
             <height>20</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>12</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Enable Selftrig <CHANNEL></string>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-SELFTRIG-ENA-<CHANNEL></string>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caToggleButton::Height</enum>
           </property>
          </widget>
         </item>
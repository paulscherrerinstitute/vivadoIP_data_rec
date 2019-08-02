<?xml version="1.0" encoding="UTF-8"?>
<ui version="4.0">
 <class>MainWindow</class>
 <widget class="QMainWindow" name="MainWindow">
  <property name="geometry">
   <rect>
    <x>0</x>
    <y>0</y>
    <width>1190</width>
    <height>710</height>
   </rect>
  </property>
  <property name="sizePolicy">
   <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
    <horstretch>0</horstretch>
    <verstretch>0</verstretch>
   </sizepolicy>
  </property>
  <property name="windowTitle">
   <string>Cavity BPM Overview</string>
  </property>
  <property name="autoFillBackground">
   <bool>false</bool>
  </property>
  <widget class="QWidget" name="centralwidget">
   <layout class="QVBoxLayout" name="verticalLayout_2">
    <property name="spacing">
     <number>2</number>
    </property>
    <property name="leftMargin">
     <number>5</number>
    </property>
    <property name="topMargin">
     <number>5</number>
    </property>
    <property name="rightMargin">
     <number>5</number>
    </property>
    <property name="bottomMargin">
     <number>5</number>
    </property>
    <item>
     <spacer name="verticalSpacer_9">
      <property name="orientation">
       <enum>Qt::Vertical</enum>
      </property>
      <property name="sizeType">
       <enum>QSizePolicy::Fixed</enum>
      </property>
      <property name="sizeHint" stdset="0">
       <size>
        <width>20</width>
        <height>1</height>
       </size>
      </property>
     </spacer>
    </item>
    <item>
     <widget class="caLabel" name="caLabel_19">
      <property name="sizePolicy">
       <sizepolicy hsizetype="Expanding" vsizetype="Fixed">
        <horstretch>0</horstretch>
        <verstretch>0</verstretch>
       </sizepolicy>
      </property>
      <property name="minimumSize">
       <size>
        <width>240</width>
        <height>30</height>
       </size>
      </property>
      <property name="sizeIncrement">
       <size>
        <width>120</width>
        <height>20</height>
       </size>
      </property>
      <property name="font">
       <font>
        <family>Lucida Sans</family>
        <pointsize>19</pointsize>
       </font>
      </property>
      <property name="text">
       <string>$(DEV)$(SYS) Data Recorder</string>
      </property>
      <property name="alignment">
       <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
      </property>
      <property name="fontScaleMode">
       <enum>ESimpleLabel::Height</enum>
      </property>
      <property name="foreground">
       <color>
        <red>0</red>
        <green>0</green>
        <blue>0</blue>
       </color>
      </property>
      <property name="background">
       <color alpha="0">
        <red>255</red>
        <green>255</green>
        <blue>255</blue>
       </color>
      </property>
      <property name="frameShape">
       <enum>QFrame::NoFrame</enum>
      </property>
     </widget>
    </item>
    <item>
     <spacer name="verticalSpacer_6">
      <property name="orientation">
       <enum>Qt::Vertical</enum>
      </property>
      <property name="sizeType">
       <enum>QSizePolicy::Fixed</enum>
      </property>
      <property name="sizeHint" stdset="0">
       <size>
        <width>20</width>
        <height>1</height>
       </size>
      </property>
     </spacer>
    </item>
    <item>
     <layout class="QHBoxLayout" name="horizontalLayout">
      <property name="spacing">
       <number>2</number>
      </property>
      <property name="leftMargin">
       <number>0</number>
      </property>
      <property name="topMargin">
       <number>0</number>
      </property>
      <property name="rightMargin">
       <number>0</number>
      </property>
      <property name="bottomMargin">
       <number>0</number>
      </property>
      <item>
       <layout class="QVBoxLayout" name="verticalLayout">
        <property name="spacing">
         <number>5</number>
        </property>
        <property name="sizeConstraint">
         <enum>QLayout::SetDefaultConstraint</enum>
        </property>
        <property name="leftMargin">
         <number>0</number>
        </property>
        <property name="topMargin">
         <number>0</number>
        </property>
        <property name="rightMargin">
         <number>0</number>
        </property>
        <property name="bottomMargin">
         <number>0</number>
        </property>
        <item>
         <spacer name="verticalSpacer_2">
          <property name="font">
           <font>
            <family>Lucida Sans</family>
            <pointsize>10</pointsize>
           </font>
          </property>
          <property name="orientation">
           <enum>Qt::Vertical</enum>
          </property>
          <property name="sizeType">
           <enum>QSizePolicy::Expanding</enum>
          </property>
          <property name="sizeHint" stdset="0">
           <size>
            <width>0</width>
            <height>0</height>
           </size>
          </property>
         </spacer>
        </item>
       </layout>
      </item>
      <item>
       <widget class="QGroupBox" name="groupBox">
        <property name="sizePolicy">
         <sizepolicy hsizetype="Fixed" vsizetype="Expanding">
          <horstretch>0</horstretch>
          <verstretch>0</verstretch>
         </sizepolicy>
        </property>
        <property name="minimumSize">
         <size>
          <width>130</width>
          <height>180</height>
         </size>
        </property>
        <property name="font">
         <font>
          <family>Lucida Sans</family>
          <pointsize>12</pointsize>
          <weight>75</weight>
          <bold>true</bold>
         </font>
        </property>
        <property name="title">
         <string>Sampling Mode</string>
        </property>
        <layout class="QVBoxLayout" name="verticalLayout_3">
         <property name="spacing">
          <number>1</number>
         </property>
         <property name="leftMargin">
          <number>5</number>
         </property>
         <property name="topMargin">
          <number>5</number>
         </property>
         <property name="rightMargin">
          <number>5</number>
         </property>
         <property name="bottomMargin">
          <number>5</number>
         </property>
         <item>
          <widget class="QLabel" name="label_33">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Fixed" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="maximumSize">
            <size>
             <width>220</width>
             <height>16777215</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Status</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caLineEdit" name="caLineEdit_17">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
             <height>15</height>
            </size>
           </property>
           <property name="maximumSize">
            <size>
             <width>16777215</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>9</pointsize>
            </font>
           </property>
           <property name="alignment">
            <set>Qt::AlignAbsolute|Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter</set>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-STATUS</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caLineEdit::Default</enum>
           </property>
           <property name="precisionMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="limitsMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="maxValue">
            <double>1.000000000000000</double>
           </property>
           <property name="minValue">
            <double>0.000000000000000</double>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caLineEdit::Height</enum>
           </property>
           <property name="formatType">
            <enum>caLineEdit::decimal</enum>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_39">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Arm</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caChoice" name="cachoice">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>35</height>
            </size>
           </property>
           <property name="maximumSize">
            <size>
             <width>16777215</width>
             <height>35</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
            </font>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-ARM</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caChoice::Static</enum>
           </property>
           <property name="endBit">
            <number>1</number>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_49">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Samples</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caTextEntry" name="caTextEntry_11">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
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
             <pointsize>10</pointsize>
            </font>
           </property>
           <property name="alignment">
            <set>Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter</set>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-TOTSPLS</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caLineEdit::Default</enum>
           </property>
           <property name="precisionMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="limitsMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="maxValue">
            <double>1.000000000000000</double>
           </property>
           <property name="minValue">
            <double>0.000000000000000</double>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caLineEdit::Height</enum>
           </property>
           <property name="formatType">
            <enum>caLineEdit::decimal</enum>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_50">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Pretrigger</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caTextEntry" name="caTextEntry_12">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
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
             <pointsize>10</pointsize>
            </font>
           </property>
           <property name="alignment">
            <set>Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter</set>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-PRETRIG</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caLineEdit::Default</enum>
           </property>
           <property name="precisionMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="limitsMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="maxValue">
            <double>1.000000000000000</double>
           </property>
           <property name="minValue">
            <double>0.000000000000000</double>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caLineEdit::Height</enum>
           </property>
           <property name="formatType">
            <enum>caLineEdit::decimal</enum>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_51">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string> Trigger Source</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caMenu" name="caMenu_8">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
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
             <pointsize>10</pointsize>
            </font>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-TRIGSRC</string>
           </property>
           <property name="colorMode">
            <enum>caMenu::Static</enum>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_58">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Trigger Event</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caMenu" name="caMenu_9">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
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
             <pointsize>10</pointsize>
            </font>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-EXTTRIG-SEL</string>
           </property>
           <property name="colorMode">
            <enum>caMenu::Static</enum>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_54">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Self Trigger High</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caTextEntry" name="caTextEntry_15">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
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
             <pointsize>10</pointsize>
            </font>
           </property>
           <property name="alignment">
            <set>Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter</set>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-SELFTRIG-HI</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caLineEdit::Default</enum>
           </property>
           <property name="precisionMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="limitsMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="maxValue">
            <double>1.000000000000000</double>
           </property>
           <property name="minValue">
            <double>0.000000000000000</double>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caLineEdit::Height</enum>
           </property>
           <property name="formatType">
            <enum>caLineEdit::decimal</enum>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_53">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Self Trigger Low</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caTextEntry" name="caTextEntry_14">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
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
             <pointsize>10</pointsize>
            </font>
           </property>
           <property name="alignment">
            <set>Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter</set>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-SELFTRIG-LO</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caLineEdit::Default</enum>
           </property>
           <property name="precisionMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="limitsMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="maxValue">
            <double>1.000000000000000</double>
           </property>
           <property name="minValue">
            <double>0.000000000000000</double>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caLineEdit::Height</enum>
           </property>
           <property name="formatType">
            <enum>caLineEdit::decimal</enum>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caToggleButton" name="catogglebutton_2">
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
            <string>Trigger on exit</string>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-SELFTRIG-ONEXIT</string>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caToggleButton::Height</enum>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caToggleButton" name="catogglebutton_3">
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
            <string>Trigger on enter</string>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-SELFTRIG-ONENTER</string>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caToggleButton::Height</enum>
           </property>
          </widget>
         </item>
 <SELFTRIG-ENA>
         <item>
          <widget class="QLabel" name="label_56">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Trigger Counter FW</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caLineEdit" name="caLineEdit_21">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
             <height>15</height>
            </size>
           </property>
           <property name="maximumSize">
            <size>
             <width>16777215</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>9</pointsize>
            </font>
           </property>
           <property name="alignment">
            <set>Qt::AlignAbsolute|Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter</set>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-TRIG-CNT-FW</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caLineEdit::Default</enum>
           </property>
           <property name="precisionMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="limitsMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="maxValue">
            <double>1.000000000000000</double>
           </property>
           <property name="minValue">
            <double>0.000000000000000</double>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caLineEdit::Height</enum>
           </property>
           <property name="unitsEnabled">
            <bool>false</bool>
           </property>
           <property name="formatType">
            <enum>caLineEdit::decimal</enum>
           </property>
          </widget>
         </item>
         <item>
          <widget class="QLabel" name="label_57">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Preferred" vsizetype="Fixed">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>0</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>10</pointsize>
             <weight>50</weight>
             <bold>false</bold>
            </font>
           </property>
           <property name="text">
            <string>Trigger Counter SW</string>
           </property>
           <property name="alignment">
            <set>Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter</set>
           </property>
          </widget>
         </item>
         <item>
          <widget class="caLineEdit" name="caLineEdit_22">
           <property name="sizePolicy">
            <sizepolicy hsizetype="Expanding" vsizetype="Expanding">
             <horstretch>0</horstretch>
             <verstretch>0</verstretch>
            </sizepolicy>
           </property>
           <property name="minimumSize">
            <size>
             <width>80</width>
             <height>15</height>
            </size>
           </property>
           <property name="maximumSize">
            <size>
             <width>16777215</width>
             <height>15</height>
            </size>
           </property>
           <property name="font">
            <font>
             <family>Lucida Sans</family>
             <pointsize>9</pointsize>
            </font>
           </property>
           <property name="alignment">
            <set>Qt::AlignAbsolute|Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter</set>
           </property>
           <property name="channel" stdset="0">
            <string notr="true">$(DEV)$(SYS)REC-TRIG-CNT-SW</string>
           </property>
           <property name="foreground">
            <color>
             <red>0</red>
             <green>0</green>
             <blue>0</blue>
            </color>
           </property>
           <property name="background">
            <color>
             <red>160</red>
             <green>160</green>
             <blue>164</blue>
            </color>
           </property>
           <property name="colorMode">
            <enum>caLineEdit::Default</enum>
           </property>
           <property name="precisionMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="limitsMode">
            <enum>caLineEdit::Channel</enum>
           </property>
           <property name="maxValue">
            <double>1.000000000000000</double>
           </property>
           <property name="minValue">
            <double>0.000000000000000</double>
           </property>
           <property name="fontScaleMode" stdset="0">
            <enum>caLineEdit::Height</enum>
           </property>
           <property name="unitsEnabled">
            <bool>false</bool>
           </property>
           <property name="formatType">
            <enum>caLineEdit::decimal</enum>
           </property>
          </widget>
         </item>
         <item>
          <spacer name="verticalSpacer">
           <property name="orientation">
            <enum>Qt::Vertical</enum>
           </property>
           <property name="sizeHint" stdset="0">
            <size>
             <width>20</width>
             <height>50</height>
            </size>
           </property>
          </spacer>
         </item>
         <item>
          <layout class="QVBoxLayout" name="verticalLayout_11"/>
         </item>
        </layout>
       </widget>
      </item>
      <item>
       <layout class="QVBoxLayout" name="verticalLayout_8">
        <item>
         <widget class="caCartesianPlot" name="caCartesianPlot_0">
          <property name="sizePolicy">
           <sizepolicy hsizetype="Expanding" vsizetype="Fixed">
            <horstretch>0</horstretch>
            <verstretch>0</verstretch>
           </sizepolicy>
          </property>
          <property name="minimumSize">
           <size>
            <width>100</width>
            <height>500</height>
           </size>
          </property>
          <property name="font">
           <font>
            <family>Lucida Sans</family>
            <pointsize>10</pointsize>
           </font>
          </property>
          <property name="Title" stdset="0">
           <string notr="true">Downconverter Data</string>
          </property>
          <property name="TitleX">
           <string>Sample</string>
          </property>
          <property name="TitleY">
           <string>Value</string>
          </property>
<WAVE-CHANNELS>
          <property name="plotMode">
           <enum>caCartesianPlot::PlotLastNPoints</enum>
          </property>
          <property name="foreground">
           <color>
            <red>0</red>
            <green>0</green>
            <blue>0</blue>
           </color>
          </property>
          <property name="background">
           <color>
            <red>0</red>
            <green>0</green>
            <blue>0</blue>
           </color>
          </property>
          <property name="scaleColor">
           <color>
            <red>255</red>
            <green>255</green>
            <blue>255</blue>
           </color>
          </property>
          <property name="XaxisScaling" stdset="0">
           <enum>caCartesianPlot::Auto</enum>
          </property>
          <property name="YaxisScaling" stdset="0">
           <enum>caCartesianPlot::Auto</enum>
          </property>
          <property name="YaxisLimits">
           <string>0;8388608</string>
          </property>
          <property name="LegendEnabled">
           <bool>false</bool>
          </property>
         </widget>
        </item>
        <item>
         <layout class="QGridLayout" name="gridLayout">
<PLOT-LABELS>
         </layout>
        </item>
       </layout>
      </item>
     </layout>
    </item>
   </layout>
  </widget>
 </widget>
 <customwidgets>
  <customwidget>
   <class>caMenu</class>
   <extends>QComboBox</extends>
   <header>caMenu</header>
  </customwidget>
  <customwidget>
   <class>caChoice</class>
   <extends>QWidget</extends>
   <header>caChoice</header>
  </customwidget>
  <customwidget>
   <class>caTextEntry</class>
   <extends>caLineEdit</extends>
   <header>caTextEntry</header>
  </customwidget>
  <customwidget>
   <class>caToggleButton</class>
   <extends>QCheckBox</extends>
   <header>caToggleButton</header>
  </customwidget>
  <customwidget>
   <class>caLabel</class>
   <extends>QLabel</extends>
   <header>caLabel</header>
  </customwidget>
  <customwidget>
   <class>caLineEdit</class>
   <extends>QLineEdit</extends>
   <header>caLineEdit</header>
  </customwidget>
  <customwidget>
   <class>caCartesianPlot</class>
   <extends>QFrame</extends>
   <header>caCartesianPlot</header>
  </customwidget>
 </customwidgets>
 <resources/>
 <connections/>
 <designerdata>
  <property name="gridDeltaX">
   <number>5</number>
  </property>
  <property name="gridDeltaY">
   <number>5</number>
  </property>
  <property name="gridSnapX">
   <bool>true</bool>
  </property>
  <property name="gridSnapY">
   <bool>true</bool>
  </property>
  <property name="gridVisible">
   <bool>true</bool>
  </property>
 </designerdata>
</ui>

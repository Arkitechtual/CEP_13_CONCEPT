<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:template name="build-section-vital-signs">
        <xsl:param name="section"/>

        <xsl:variable name="table-id">vital-signs-table</xsl:variable>
        <xsl:variable name="section-title">VITAL SIGNS / CLINICAL RESULTS (Last 4 Results)</xsl:variable>
        <xsl:variable name="summary-div-id">vital-signs-summary</xsl:variable>
        <xsl:variable name="details-div-id">vital-signs-details</xsl:variable>
        <xsl:variable name="all-div-id">vital-signs-all</xsl:variable>

        <!-- we count maximal number of columns -->
        <xsl:variable name="v1">
            <root>
                <xsl:for-each select="$section">
                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <foo>
                            <xsl:value-of select="normalize-space(./MEASUREMENT_NAME)"/>
                        </foo>
                    </xsl:if>
                </xsl:for-each>
            </root>
        </xsl:variable>

        <xsl:variable name="unique-list-component-names" select="$v1/root/foo[not(.=following::foo)]"/>

        <xsl:variable name="v1-count">
            <xsl:for-each select="$v1/root/foo">
                <root>
                    <foo>
                        <xsl:call-template name="getCount">
                            <xsl:with-param name="i">
                                <xsl:value-of select="."/>
                            </xsl:with-param>
                            <xsl:with-param name="section" select="$section"/>
                        </xsl:call-template>
                    </foo>
                </root>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="v2">
            <xsl:for-each select="$v1-count/root/foo">
                <xsl:sort select="." data-type="number"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="biggestCount">
            <xsl:for-each select="$v2/foo">
                <xsl:if test="position() = last()">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <div class="wrap_window">
            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-vital-signs">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
                <xsl:with-param name="biggestCount">
                    4
                </xsl:with-param>
                <xsl:with-param name="unique-list-component-names" select="$unique-list-component-names"/>
                <xsl:with-param name="display">
                    block
                </xsl:with-param>
            </xsl:call-template>


            <xsl:call-template name="section-vital-signs">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
                <xsl:with-param name="biggestCount" select="$biggestCount"/>
                <xsl:with-param name="unique-list-component-names" select="$unique-list-component-names"/>
                <xsl:with-param name="display">
                    none
                </xsl:with-param>
            </xsl:call-template>

            <!-- <xsl:call-template name="section-vital-signs">
              <xsl:with-param name="section" select="$section"/>
              <xsl:with-param name="div-id" select="$all-div-id"/>
              <xsl:with-param name="biggestCount" select="$biggestCount"/>
              <xsl:with-param name="unique-list-component-names" select="$unique-list-component-names"/>
              <xsl:with-param name="display">
                  none
              </xsl:with-param>
          </xsl:call-template>  -->

        </div>

    </xsl:template>


    <!-- loop for empty cells -->
    <xsl:template name="component.for.loop">
        <xsl:param name="i"/>
        <xsl:param name="count"/>
        <xsl:param name="width"/>

        <td width="100px">
            <xsl:attribute name="width">
                <xsl:value-of select="normalize-space($width)"/>
            </xsl:attribute>
        </td>


        <xsl:if test="$i &lt; $count">
            <xsl:call-template name="component.for.loop">
                <xsl:with-param name="i">
                    <xsl:value-of select="$i + 1"/>
                </xsl:with-param>
                <xsl:with-param name="count">
                    <xsl:value-of select="$count"/>
                </xsl:with-param>
                <xsl:with-param name="width">
                    <xsl:value-of select="$width"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="getCount">
        <xsl:param name="i"/>
        <xsl:param name="section"/>

        <xsl:variable name="countingComponents">
            <xsl:for-each select="$section">
                <xsl:variable name="status" select="./STATUS"/>
                <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>
                <xsl:if test="$statusUpCase != 'IN ERROR'">
                    <xsl:for-each select="./MEASUREMENT_NAME[normalize-space(text())=$i]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="count($countingComponents)"/>
    </xsl:template>


    <!-- we build header row for table -->
    <xsl:template name="buildTableHeader">
        <xsl:param name="value"/>
        <xsl:param name="valueStop"/>
        <xsl:param name="width"/>


        <xsl:choose>
            <xsl:when test="$value = 1">
                <col class="sorttable_nosort">
                    <xsl:attribute name="width">
                        <xsl:value-of select="$width"/>
                    </xsl:attribute>
                    Most Recent
                </col>
            </xsl:when>
            <xsl:otherwise>
                <col class="sorttable_nosort">
                    <xsl:attribute name="width">
                        <xsl:value-of select="$width"/>
                    </xsl:attribute>
                    Previous
                </col>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$value &lt; $valueStop">
            <xsl:call-template name="buildTableHeader">
                <xsl:with-param name="value" select="$value + 1"/>
                <xsl:with-param name="valueStop" select="$valueStop"/>
                <xsl:with-param name="width" select="$width"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xsl:template name="section-vital-signs">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>
        <xsl:param name="biggestCount"/>
        <xsl:param name="unique-list-component-names"/>
        <xsl:param name="display"/>


        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="$div-id = 'vital-signs-summary'">
                    <xsl:text>75</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>75</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- WIDTH: <xsl:value-of select="$width" />
        LAST MEMBER WIDTH: <xsl:value-of select="$last-member-width" />
         -->

        <xsl:variable name="cols">
            <cols scrolling="true">
                <xsl:choose>
                    <xsl:when test="$div-id = 'vital-signs-summary'">
                        <col width="200">Name/Measurement</col>
                    </xsl:when>
                    <xsl:otherwise>
                        <col width="200">Name/Measurement</col>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- build a header col -->
                <xsl:call-template name="buildTableHeader">
                    <xsl:with-param name="value">1</xsl:with-param>
                    <xsl:with-param name="valueStop">
                        <xsl:value-of select="$biggestCount"/>
                    </xsl:with-param>
                    <xsl:with-param name="width" select="$width"/>
                </xsl:call-template>
            </cols>
        </xsl:variable>


        <div id="{$div-id}" class="scrollRoot">
            <xsl:attribute name="style">display:<xsl:value-of select="normalize-space($display)"/>
            </xsl:attribute>
            <!-- style="display: block;" -->


            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="normalize-space($div-id)"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row-vitals">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable">
                    <xsl:attribute name="id"><xsl:value-of select="normalize-space($div-id)"/>-table</xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row-vitals">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="string-length($unique-list-component-names)=0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$unique-list-component-names">
                        <tr>

                            <!-- take a component code -->
                            <xsl:variable name="componentcode" select="."/>

                            <xsl:variable name="component">
                                <xsl:for-each select="$section">
                                    <xsl:variable name="status" select="./STATUS"/>
                                    <xsl:variable name="statusUpCase"
                                                  select="translate($status, $smallcase, $uppercase)"/>
                                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                                        <xsl:if test="./MEASUREMENT_NAME[text()=$componentcode]">
                                            <xsl:copy-of select="."/>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>

                            <td width="200px">
                                <xsl:value-of select="$componentcode"/>
                                <br/>
                            </td>

                            <!-- and iterate over all componets with same section code and add them into the row-->
                            <xsl:for-each select="$component/vital">
                                <xsl:sort select="./OBSERVATION_DATE" order="descending"/>

                                <xsl:variable name="rrange">
                                    <xsl:choose>
                                        <xsl:when test="./LOW_VALUE">
                                            Ref Range:<xsl:value-of select="./LOW_VALUE"/>-<xsl:value-of select="./HIGH_VALUE"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            Ref Range Not Found
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="low" select="./LOW_VALUE"/>
                                <xsl:variable name="high" select="./HIGH_VALUE"/>

                                <xsl:variable name="meas"
                                              select="normalize-space(./MEASUREMENT_NAME)"/>

                                <xsl:if test="position() &lt;= $biggestCount ">
                                    <xsl:variable name="date"
                                                  select="normalize-space(./OBSERVATION_DATE)"/>
                                    <xsl:variable name="val">
                                        <xsl:value-of select="./VALUE"/>
                                    </xsl:variable>
                                    <td>
                                        <xsl:attribute name="width"><xsl:value-of select="normalize-space($width)"/><xsl:text>px</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="class">
                                            <xsl:choose>
                                                <xsl:when test="matches($rrange,'\d+')">
                                                    <xsl:choose>
                                                        <xsl:when test="$val &lt; $low or $val &gt; $high">
                                                            <xsl:text>outOfRange</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>normal</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>noData</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>


                                        <div class="tooltip_link">


                                            <xsl:value-of select="$val"/>&#160;<xsl:value-of
                                                select="normalize-space(./VALUE_UNIT)"/>
                                            <!--,
                                            <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;
                                                <xsl:call-template name="print-age">
                                                    <xsl:with-param name="first-date" select="$date"/>
                                                </xsl:call-template>
                                            </span>-->


                                            <div class="tooltip" style="display: none;">
                                                <div class="top"></div>
                                                <div class="middle">

                                                    <xsl:variable name="measu" select="upper-case($meas)"/>
                                                    <xsl:if test="matches($measu,'TEMPERATURE')">
                                                        Route:<xsl:value-of select="tokenize($measu,'TEMPERATURE')[1]"/><xsl:value-of
                                                            select="tokenize($measu,'TEMPERATURE')[2]"/>
                                                        <br/>
                                                    </xsl:if>
                                                    <xsl:if test="matches($measu,'PULSE RATE')">
                                                        Location:<xsl:value-of
                                                            select="tokenize($measu,'PULSE RATE')[1]"/><xsl:value-of
                                                            select="tokenize($measu,'PULSE RATE')[2]"/>
                                                        <br/>
                                                    </xsl:if>
                                                    <xsl:if test="matches($measu,'BLOOD PRESSURE')">
                                                        Type:<xsl:value-of
                                                            select="tokenize($measu,'BLOOD PRESSURE')[1]"/><xsl:value-of
                                                            select="tokenize($measu,'BLOOD PRESSURE')[2]"/>
                                                        <br/>
                                                    </xsl:if>

                                                    <xsl:if test="matches($measu,'HEART RATE')">
                                                        <xsl:value-of select="$rrange"/>
                                                        <br/>
                                                    </xsl:if>
                                                    <xsl:if test="matches($measu,'PULSE RATE')">
                                                        <xsl:value-of select="$rrange"/>
                                                        <br/>
                                                    </xsl:if>
                                                    <xsl:if test="matches($measu,'TEMPERATURE')">
                                                        <xsl:value-of select="$rrange"/>
                                                        <br/>
                                                    </xsl:if>
                                                    <xsl:if test="matches($measu,'BLOOD PRESSURE')">
                                                        <xsl:value-of select="$rrange"/>
                                                        <br/>
                                                    </xsl:if>


                                                    Date/Time:
                                                    <xsl:call-template name="format-date">
                                                        <xsl:with-param name="date" select="$date"/>
                                                    </xsl:call-template>
                                                    &#160;
                                                    <xsl:call-template name="format-time">
                                                        <xsl:with-param name="date" select="$date"/>
                                                    </xsl:call-template>
                                                    <br/>


                                                    Source:
                                                    <xsl:call-template name="translate-source">
                                                        <xsl:with-param name="id-tag" select="./SOURCE"/>
                                                    </xsl:call-template>
                                                </div>
                                                <div class="bottom"></div>
                                            </div>
                                        </div>
                                    </td>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- add an empty <td></td> because of filling the table -->
                            <xsl:if test="count($component/vital) &lt; $biggestCount">
                                <xsl:call-template name="component.for.loop">
                                    <xsl:with-param name="i" select="count($component/vital)"/>
                                    <xsl:with-param name="count" select="$biggestCount - 1"/>
                                    <xsl:with-param name="width" select="$width"/>
                                </xsl:call-template>
                            </xsl:if>
                        </tr>
                    </xsl:for-each>

                </table>

            </div>

        </div>
    </xsl:template>


</xsl:stylesheet>
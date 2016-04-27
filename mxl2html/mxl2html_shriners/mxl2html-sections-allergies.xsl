<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:template name="build-section-allergies">
        <xsl:param name="section"/>

        <xsl:variable name="table-id">allergies-table</xsl:variable>
        <xsl:variable name="section-title">Allergies</xsl:variable>
        <xsl:variable name="summary-div-id">allergies-summary</xsl:variable>
        <xsl:variable name="details-div-id">allergies-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-allergies-summary">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-allergies-details">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>

        </div>

    </xsl:template>


    <xsl:template name="section-allergies-summary">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Allergy</col>
                <col width="20">Status</col>
                <col width="30">Reaction</col>
                <col width="20">Severity</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <div id="{$div-id}" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>
                    <!--  WHAT?
                    <xsl:if test="string-length($section/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.10.20.1.39']/../hl7:value[translate(@displayName, $smallcase, $uppercase) = 'ACTIVE']/@displayName) = 0">
						<span class="empty-table">No records found</span>
					</xsl:if>
                     -->
                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                    <xsl:if test="count($section) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:for-each select="$section">
                        <xsl:variable name="status">
                            <xsl:value-of select="./STATUS"/>
                        </xsl:variable>
                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>
                        <xsl:if test="$statusUpCase = 'ACTIVE' or $statusUpCase = ''">
                            <tr>
                                <xsl:if test="./SEVERITY != ''">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="./SEVERITY"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <td width="{$cols/cols/col[position() = 1]/@width}%"><!-- add an allergy class with the severity attached -->
                                    <span>
                                        <xsl:if test="./SEVERITY != ''">
                                            <xsl:attribute name="class">
                                                <xsl:value-of select="./SEVERITY"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="./ALLERGY"/>
                                    </span>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%"><!-- STATUS 0  -->
                                    <xsl:value-of select="./STATUS"/>
                                </td>

                                <td width="{$cols/cols/col[position() = 3]/@width}%"><!-- reaction -->
                                    <xsl:value-of select="./REACTIONS"/>

                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%"><!-- severity -->
                                    <xsl:value-of select="./SEVERITY"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:call-template name="translate-source">
                                        <xsl:with-param name="id-tag" select="./SOURCE"/>
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </table>

            </div>

        </div>
    </xsl:template>

    <xsl:template name="section-allergies-details">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="15">Substance</col>
                <col width="10">Category</col>
                <col width="13">Reaction</col>
                <col width="10">Severity</col>
                <col width="10">Reaction type</col>
                <col width="5">Status</col>
                <col width="10">Date Reported</col>
                <col width="10">Last Updated By</col>
                <col width="10">Comments</col>
                <col width="7">Source</col>
            </cols>
        </xsl:variable>

        <div id="{$div-id}" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="900">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">

                <table class="sectiontable sortable" minimal="900">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>
                    <!--
                    <xsl:if test="string-length($section/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.10.20.1.39']/../hl7:value[translate(@displayName, $smallcase, $uppercase) = 'ACTIVE']/@displayName) = 0">
                        <span class="empty-table">No records found</span>
                    </xsl:if>
                    -->
                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                    <xsl:if test="count($section) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:for-each select="$section">

                        <xsl:variable name="status">
                            <xsl:value-of select="./STATUS"/>
                        </xsl:variable>
                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

                        <xsl:if test="$statusUpCase = 'ACTIVE' or $statusUpCase = ''">
                            <tr>
                                <xsl:if test="./SEVERITY != ''">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="./SEVERITY"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <td width="{$cols/cols/col[position() = 1]/@width}%"><!--substance ( Allergy ) --><!-- add an allergy class with the severity attached -->
                                    <span>
                                        <xsl:if test="./SEVERITY != ''">
                                            <xsl:attribute name="class">
                                                <xsl:value-of select="./SEVERITY"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="./ALLERGY"/>
                                    </span>
                                </td>

                                <td width="{$cols/cols/col[position() = 2]/@width}%"><!-- category -->
                                    <xsl:value-of select="./CATEGORY"/>
                                </td>

                                <td width="{$cols/cols/col[position() = 3]/@width}%"><!-- reaction -->
                                    <xsl:value-of select="./REACTIONS"/>
                                </td>

                                <td width="{$cols/cols/col[position() = 4]/@width}%"><!-- severity -->
                                    <xsl:value-of select="./SEVERITY"/>
                                </td>

                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:value-of select="./REACTION_TYPE"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 6]/@width}%"><!-- STATUS 1  -->
                                    <xsl:value-of select="./STATUS"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 7]/@width}%"><!-- verified -->
                                    <xsl:if test="./DATE_REPORTED !=''">
                                        <xsl:call-template name="format-date">
                                            <xsl:with-param name="date" select="./DATE_REPORTED"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </td>
                                <td width="{$cols/cols/col[position() = 8]/@width}%">
                                    <!-- updated -->
                                </td>
                                <td width="{$cols/cols/col[position() = 9]/@width}%"> <!-- comments -->
                                    <xsl:for-each select="./COMMENTS">
                                        <xsl:if test=".!=''">
                                            <xsl:value-of select="."/>
                                            <xsl:if test="position()!=last()">
                                                <br/><br/>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:for-each>
                                </td>
                                <td width="{$cols/cols/col[position() = 10]/@width}%">
                                    <!-- source -->
                                    <xsl:call-template name="translate-source">
                                        <xsl:with-param name="id-tag" select="./SOURCE"/>
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </table>

            </div>

        </div><div> </div>
    </xsl:template>


</xsl:stylesheet>
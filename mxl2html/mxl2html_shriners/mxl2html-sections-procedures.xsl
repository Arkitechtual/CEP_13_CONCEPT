<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />


    <xsl:template name="build-section-procedures">
        <xsl:param name="section"/>

        <xsl:variable name="section-title">Procedures</xsl:variable>
        <xsl:variable name="table-id">procedures-table</xsl:variable>
        <xsl:variable name="summary-div-id">procedures-summary</xsl:variable>
        <xsl:variable name="details-div-id">procedures-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-procedures-summary">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-procedures-details">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>

          </div>
    </xsl:template>


    <xsl:template name="section-procedures-summary">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Procedure</col>
                <col width="20">Code</col>
                <col width="20">Date</col>
                <col width="20">Perfomer</col>
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

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="(count($section) = 0)">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$section">
                        <xsl:variable name="procedure">
                            <xsl:value-of select="./PROCEDURE"/>
                        </xsl:variable>
                        <xsl:variable name="code0">
                            <xsl:if test="./PROCEDURE_CODE_SOURCE_NAME != ''">
                                <xsl:value-of select="./PROCEDURE_CODE"/>
                                (<xsl:value-of select="./PROCEDURE_CODE_SOURCE_NAME"/>)
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="./PROCEDURE_DATETIME"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="performer">
                            <xsl:call-template name="get-surgeon-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <tr>
                            <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="normalize-space($procedure)" /></td>
                            <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="normalize-space($code0)" /></td>
                            <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:value-of select="normalize-space($date)" /></td>
                            <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="normalize-space($performer)" /></td>
                            <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="normalize-space($source)" /></td>
                        </tr>
                    </xsl:for-each>
                </table>
             </div>
        </div>
    </xsl:template>


    <xsl:template name="section-procedures-details">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="10">Procedure</col>
                <col width="10">Code</col>
                <col width="10">Date</col>
                <col width="10">Perfomer</col>
                <col width="10">Comments</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <div id="{$div-id}" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
				<table class="sectiontable sortable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="(count($section) = 0)">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$section">
                        <xsl:variable name="procedure">
                            <xsl:value-of select="./PROCEDURE"/>
                        </xsl:variable>
                        <xsl:variable name="code0">
                            <xsl:if test="./PROCEDURE_CODE_SOURCE_NAME != ''">
                                <xsl:value-of select="./PROCEDURE_CODE"/>
                                (<xsl:value-of select="./PROCEDURE_CODE_SOURCE_NAME"/>)
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="./PROCEDURE_DATETIME"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="performer">
                            <xsl:call-template name="get-surgeon-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="comments">
                            <xsl:value-of select="./COMMENTS"/>
                        </xsl:variable>

                        <tr>
                                <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="normalize-space($procedure)" /></td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="normalize-space($code0)" /></td>
                                <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:value-of select="$date"/></td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="normalize-space($performer)" /></td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="normalize-space($comments)" /></td>
                                <td width="{$cols/cols/col[position() = 6]/@width}%"><xsl:value-of select="normalize-space($source)" /></td>
                        </tr>
                    </xsl:for-each>
                </table>
	         </div>
        </div><div> </div>
    </xsl:template>

</xsl:stylesheet>
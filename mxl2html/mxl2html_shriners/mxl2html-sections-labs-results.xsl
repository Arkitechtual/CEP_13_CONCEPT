<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>


    <xsl:template name="build-section-labs-results">
        <xsl:param name="organizer"/>

        <xsl:variable name="section-title">LAB RESULTS (Past 6 months displayed on default)</xsl:variable>
        <xsl:variable name="table-id">labs-results-table</xsl:variable>
        <xsl:variable name="summary-div-id">labs-results-summary</xsl:variable>
        <xsl:variable name="details-div-id">labs-results-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-labs-results-summary">
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-labs-results-details">
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>

        </div>
    </xsl:template>


    <xsl:template name="section-labs-results-summary">
        <xsl:param name="organizer"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Order Name</col>
                <col width="20">Results</col>
                <col width="15">Value</col>
                <col width="20">Reference Range</col>
                <col width="15">Date Resulted</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <!-- summary all -->

        <div id="labs-results-summary" class="scrollRoot">
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
                <table width="98%" class="sectiontable sortable labdata grouped">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">1</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">6months</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>

                </table>

            </div>

        </div><div> </div>


        <!-- summary 1 year -->

        <div id="labs-results-summary-1year" class="scrollRoot" style="display: none;">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-1year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table width="98%" class="sectiontable sortable labdata grouped">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-1year-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">1</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">1year</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>

                </table>

            </div>

        </div><div> </div>

        <!-- summary 18 month -->

        <div id="labs-results-summary-18months" class="scrollRoot" style="display: none;">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-18months-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table width="98%" class="sectiontable sortable labdata grouped">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-18months-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">1</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">18months</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>

                </table>

            </div>

        </div><div> </div>

        <!-- summary 2 year -->

        <div id="labs-results-summary-2year" class="scrollRoot" style="display: none;">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-2year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table width="98%" class="sectiontable sortable labdata grouped">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-2year-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">1</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">2year</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>


                </table>

            </div>

        </div><div> </div>

        <!-- summary 3 year -->

        <div id="labs-results-summary-3year" class="scrollRoot" style="display: none;">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-3year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table width="98%" class="sectiontable sortable labdata grouped">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-3year-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">1</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">3year</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
                </table>

            </div>

        </div><div> </div>


        <!-- summary all -->

        <div id="labs-results-summary-all" class="scrollRoot" style="display: none;">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-all-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table width="98%" class="sectiontable sortable labdata grouped">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-all-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">1</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">all</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>

                </table>

            </div>

        </div><div> </div>

    </xsl:template>


    <xsl:template name="section-labs-results-details">
        <xsl:param name="organizer"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Order Name</col>
                <col width="10">Results</col>
                <col width="10">Value</col>
                <col width="10">Reference Range</col>
                <col width="10">Date Resulted</col>
                <col width="20">Comments</col>
                <col width="10">Resulted By</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <!-- details 6 monts -->

        <div id="labs-results-details" class="scrollRoot" style="display: none">

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
                <table class="sectiontable sortable labdata" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">0</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">6months</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>

                </table>

            </div>

        </div><div> </div>

        <!-- details 1 year -->

        <div id="labs-results-details-1year" class="scrollRoot" style="display: none">

            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-1year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable labdata" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-1year-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">0</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">1year</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>

                </table>

            </div>

        </div><div> </div>

        <!-- details 18months -->

        <div id="labs-results-details-18months" class="scrollRoot" style="display: none">

            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-18months-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable labdata" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-18months-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">0</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">18months</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>


                </table>

            </div>

        </div><div> </div>

        <!-- 2year -->

        <div id="labs-results-details-2year" class="scrollRoot" style="display: none">

            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-2year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable labdata" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-2year-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">0</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">2year</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>

                </table>

            </div>

        </div><div> </div>

        <!-- 3year -->

        <div id="labs-results-details-3year" class="scrollRoot" style="display: none">

            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-3year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable labdata" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-3year-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">0</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">3year</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>


                </table>

            </div>

        </div><div> </div>

        <!-- details all -->

        <div id="labs-results-details-all" class="scrollRoot" style="display: none">

            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-all-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable labdata" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-all-table</xsl:attribute>
                    <xsl:attribute name="count"><xsl:value-of select="count($organizer)"/></xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:variable name="status" select="./STATUS"/>
                    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />
                    <xsl:if test="$statusUpCase != 'IN ERROR'">
                        <xsl:for-each select="$organizer">
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->
                            <xsl:call-template name="make-observations-row">
                                <xsl:with-param name="observation" select="."/>
                                <xsl:with-param name="summary">0</xsl:with-param>
                                <xsl:with-param name="cols" select="$cols"/>
                                <xsl:with-param name="table">all</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>


                </table>

            </div>

        </div><div> </div>


    </xsl:template>


    <xsl:template name="make-observations-row">
        <xsl:param name="observation"/>
        <xsl:param name="summary"/>
        <xsl:param name="table"/>
        <xsl:param name="cols"/>

        <xsl:variable name="result">
            <xsl:value-of select="$observation/RESULT"/>
        </xsl:variable>
        <xsl:variable name="code-name">
            <xsl:value-of select="$observation/ORDER_CODE"/>
        </xsl:variable>

        <xsl:variable name="value">
            <xsl:value-of select="$observation/VALUE"/>
            <xsl:if test="$observation/VALUE_UNIT != ''">
                <xsl:text> </xsl:text><xsl:value-of select="translate($observation/VALUE_UNIT, '?', '^')"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="interpretationCode" select="$observation/INTERPRETATION_CODE"/>

        <xsl:variable name="reference-range">
            <xsl:value-of select="$observation/LOW_VALUE"/>
            <xsl:if test="$observation/HIGH_VALUE != ''"> - <xsl:value-of select="$observation/HIGH_VALUE"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="date-results">
            <xsl:call-template name="format-date">
                <xsl:with-param name="date" select="$observation/RESULT_DATE"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="age-results">
            <xsl:choose>
                <xsl:when test="contains($observation/RESULT_DATE,'.')">
                    <xsl:call-template name="print-age">
                        <xsl:with-param name="first-date" select="substring-before($observation/RESULT_DATE,'.')"/>
                        <xsl:with-param name="print-month" select="0"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="print-age">
                        <xsl:with-param name="first-date" select="$observation/RESULT_DATE"/>
                        <xsl:with-param name="print-month" select="0"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- TODO!!! -->
        <xsl:variable name="updated-results">
            <xsl:call-template name="get-performer-name">
                <xsl:with-param name="name-tag" select="$observation"/>
            </xsl:call-template>
        </xsl:variable>


        <xsl:variable name="source-results">
            <xsl:call-template name="translate-source">
                <xsl:with-param name="id-tag" select="$observation/SOURCE"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="lab-result-year" select="substring($observation/RESULT_DATE,0,5)"/>
        <xsl:variable name="lab-result-month" select="substring($observation/RESULT_DATE,5,2)"/>

        <xsl:variable name="current-year" select="substring(current-date(),0,5)"/>
        <xsl:variable name="current-month" select="substring(current-date(),6,2)"/>

        <xsl:variable name="months-between">
            <xsl:call-template name="get-months-between">
                <xsl:with-param name="labyear" select="$lab-result-year"/>
                <xsl:with-param name="labmonth" select="$lab-result-month"/>
                <xsl:with-param name="currentyear" select="$current-year"/>
                <xsl:with-param name="currentmonth" select="$current-month"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="order-name">
            <xsl:value-of select="./ORDER_NAME"/>
        </xsl:variable>


        <xsl:if test="$summary = 1">
            <xsl:if test="$table = '6months'">
                <xsl:if test="$months-between &lt;= 6">
                    <tr code="{$code-name}">
                        <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                            <xsl:attribute name="class">Severe</xsl:attribute>
                        </xsl:if>
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">Severe</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '1year'">
                <xsl:if test="$months-between &lt;= 12 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                            <xsl:attribute name="class">Severe</xsl:attribute>
                        </xsl:if>
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">Severe</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '18months'">
                <xsl:if test="$months-between &lt;= 18 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                            <xsl:attribute name="class">Severe</xsl:attribute>
                        </xsl:if>
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">Severe</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '2year'">
                <xsl:if test="$months-between &lt;= 24 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                            <xsl:attribute name="class">Severe</xsl:attribute>
                        </xsl:if>
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">Severe</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '3year'">
                <xsl:if test="$months-between &lt;= 48 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                            <xsl:attribute name="class">Severe</xsl:attribute>
                        </xsl:if>
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">Severe</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = 'all'">
                <tr code="{$code-name}">
                    <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                        <xsl:attribute name="class">Severe</xsl:attribute>
                    </xsl:if>
                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                        <xsl:value-of select="$order-name"/>
                    </td>
                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                        <xsl:value-of select="$result"/>
                    </td>
                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                        <span>
                            <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                <xsl:attribute name="class">Severe</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$value"/>
                        </span>
                    </td>
                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                        <xsl:value-of select="$reference-range"/>
                    </td>
                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                        <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                            <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                    select="$age-results"/>
                            </span>
                        </xsl:if>
                    </td>
                    <td width="{$cols/cols/col[position() = 6]/@width}%">
                        <xsl:value-of select="$source-results"/>
                    </td>
                </tr>
            </xsl:if>

        </xsl:if>

        <xsl:if test="$summary = 0">
            <xsl:if test="$table = '6months'">
                <xsl:if test="$months-between &lt;= 6">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">resultAbnormal</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:for-each select="./COMMENTS">
                                <xsl:if test=".!=''">
                                    <xsl:copy-of select="."/>
                                    <xsl:if test="position()!=last()">
                                        <br/><br/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </td>
                        <td width="{$cols/cols/col[position() = 7]/@width}%">
                            <xsl:value-of select="$updated-results"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 8]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '1year'">
                <xsl:if test="$months-between &lt;= 12 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">resultAbnormal</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:for-each select="./COMMENTS">
                                <xsl:if test=".!=''">
                                    <xsl:copy-of select="."/>
                                    <xsl:if test="position()!=last()">
                                        <br/><br/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </td>
                        <td width="{$cols/cols/col[position() = 7]/@width}%">
                            <xsl:value-of select="$updated-results"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 8]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '18months'">
                <xsl:if test="$months-between &lt;= 18 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">resultAbnormal</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:for-each select="./COMMENTS">
                                <xsl:if test=".!=''">
                                    <xsl:copy-of select="."/>
                                    <xsl:if test="position()!=last()">
                                        <br/><br/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </td>
                        <td width="{$cols/cols/col[position() = 7]/@width}%">
                            <xsl:value-of select="$updated-results"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 8]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '2year'">
                <xsl:if test="$months-between &lt;= 24 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">resultAbnormal</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:for-each select="./COMMENTS">
                                <xsl:if test=".!=''">
                                    <xsl:copy-of select="."/>
                                    <xsl:if test="position()!=last()">
                                        <br/><br/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </td>
                        <td width="{$cols/cols/col[position() = 7]/@width}%">
                            <xsl:value-of select="$updated-results"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 8]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '3year'">
                <xsl:if test="$months-between &lt;= 48 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%">
                            <xsl:value-of select="$order-name"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%">
                            <xsl:value-of select="$result"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%">
                            <span>
                                <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                    <xsl:attribute name="class">resultAbnormal</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$value"/>
                            </span>
                        </td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%">
                            <xsl:value-of select="$reference-range"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%">
                            <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                                <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                        select="$age-results"/>
                                </span>
                            </xsl:if>
                        </td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%">
                            <xsl:for-each select="./COMMENTS">
                                <xsl:if test=".!=''">
                                    <xsl:copy-of select="."/>
                                    <xsl:if test="position()!=last()">
                                        <br/><br/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </td>
                        <td width="{$cols/cols/col[position() = 7]/@width}%">
                            <xsl:value-of select="$updated-results"/>
                        </td>
                        <td width="{$cols/cols/col[position() = 8]/@width}%">
                            <xsl:value-of select="$source-results"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = 'all'">
                <tr code="{$code-name}">
                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                        <xsl:value-of select="$order-name"/>
                    </td>
                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                        <xsl:value-of select="$result"/>
                    </td>
                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                        <span>
                            <xsl:if test="$interpretationCode != 'N' and $interpretationCode != 'NA' and $interpretationCode != ''">
                                <xsl:attribute name="class">resultAbnormal</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$value"/>
                        </span>
                    </td>
                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                        <xsl:value-of select="$reference-range"/>
                    </td>
                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                        <xsl:if test="$date-results!=''"><xsl:value-of select="$date-results"/>,
                            <span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of
                                    select="$age-results"/>
                            </span>
                        </xsl:if>
                    </td>
                    <td width="{$cols/cols/col[position() = 6]/@width}%">
                        <xsl:for-each select="./COMMENTS">
                            <xsl:if test=".!=''">
                                <xsl:copy-of select="."/>
                                <xsl:if test="position()!=last()">
                                    <br/><br/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                    <td width="{$cols/cols/col[position() = 7]/@width}%">
                        <xsl:value-of select="$updated-results"/>
                    </td>
                    <td width="{$cols/cols/col[position() = 8]/@width}%">
                        <xsl:value-of select="$source-results"/>
                    </td>
                </tr>
            </xsl:if>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
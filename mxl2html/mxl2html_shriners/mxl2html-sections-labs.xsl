<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>
    
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    
       <xsl:template name="build-section-labs">
        <xsl:param name="organizer"/>

        <xsl:variable name="section-title">LAB ORDERS (Past 6 months displayed on default)</xsl:variable>
        <xsl:variable name="table-id">labs-table</xsl:variable>
        <xsl:variable name="summary-div-id">labs-summary</xsl:variable>
        <xsl:variable name="details-div-id">labs-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-labs-summary">
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-labs-details">
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>
            
        </div>
    </xsl:template>
    
    
    
    
    <xsl:template name="section-labs-summary">
        <xsl:param name="organizer"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="30">Order Name</col>
                <col width="20">Ordering Provider</col>
                <col width="20">Date Ordered</col>
                <col width="20">Status</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <!-- summary -->

        <div id="labs-summary" class="scrollRoot">
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
	           <table class="sectiontable sortable labdata">
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
                    
                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >1</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >6months</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >
                    
                </table>
	
	         </div>

        </div><div> </div>

        <!-- 1 year -->

        <div id="labs-summary-1year" class="scrollRoot" style="display: none;">
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
	           <table class="sectiontable sortable labdata">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >1</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >1year</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

        <!-- 18 month -->

        <div id="labs-summary-18months" class="scrollRoot" style="display: none;">
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
	           <table class="sectiontable sortable labdata">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >


                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >1</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >18months</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

        <!-- 2 year -->

        <div id="labs-summary-2year" class="scrollRoot" style="display: none;">
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
	           <table class="sectiontable sortable labdata">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >1</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >2year</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

        <!-- 3 year -->

        <div id="labs-summary-3year" class="scrollRoot" style="display: none;">
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
	           <table class="sectiontable sortable labdata">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >1</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >3year</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

        <!-- all -->

        <div id="labs-summary-all" class="scrollRoot" style="display: none;">
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
	           <table class="sectiontable sortable labdata">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >1</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >all</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

    </xsl:template>	
    
    
     <xsl:template name="section-labs-details">
        <xsl:param name="organizer"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Order Name</col>
                <col width="20">Ordering Provider</col>
                <col width="20">Date Ordered</col>
                <col width="20">Status</col>
                <col width="10">Comments</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <!-- lab details -->

        <div id="labs-details" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="700">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
				<table class="sectiontable sortable labdata"  minimal="700">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >0</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >6months</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >
                    
                </table>
	
	         </div>

        </div><div> </div>


         <!-- lab details 1 year -->

        <div id="labs-details-1year" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable"  minimal="700">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-1year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
				<table class="sectiontable sortable labdata"  minimal="700">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >0</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >1year</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

                </table>

	         </div>

        </div><div> </div>

          <!-- lab details 18 months -->

        <div id="labs-details-18months" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable"  minimal="700">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-18months-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
				<table class="sectiontable sortable labdata"  minimal="700">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >0</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >18months</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

         <!-- lab details 2 year -->

        <div id="labs-details-2year" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable"  minimal="700">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-2year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
				<table class="sectiontable sortable labdata"  minimal="700">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >0</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >2year</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

        <!-- lab details 3 year -->

        <div id="labs-details-3year" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable"  minimal="700">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-3year-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
				<table class="sectiontable sortable labdata"  minimal="700">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >0</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >3year</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

         <!-- lab details all -->

        <div id="labs-details-all" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable"  minimal="700">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-all-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
				<table class="sectiontable sortable labdata"  minimal="700">
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

                    <xsl:for-each select="$organizer">  <!-- loop thru each header-organizer -->
                            <!--<xsl:sort select="./RESULT_DATE" order="descending"/>
                            <xsl:sort select="./ORDER_NAME"/>-->

						<xsl:call-template name="make-organizer-row" >
                  			<xsl:with-param name="organizer-order" select="." />
                  			<xsl:with-param name="summary" >0</xsl:with-param>
                  			<xsl:with-param name="cols" select="$cols" />
                            <xsl:with-param name="table" >all</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each >

                </table>

	         </div>

        </div><div> </div>

    </xsl:template>	

<xsl:template name="make-organizer-row">
    <xsl:param name="organizer-order" />
    <xsl:param name="summary" />
	<xsl:param name="table" />
    <xsl:param name="cols" />

	<xsl:variable name="lab-year" select="substring($organizer-order/RESULT_DATE,0,5)" />
	<xsl:variable name="lab-month" select="substring($organizer-order/RESULT_DATE,5,2)" />

	<xsl:variable name="current-year" select="substring(current-date(),0,5)" />
	<xsl:variable name="current-month" select="substring(current-date(),6,2)" />

	<xsl:variable name="months-between">
		<xsl:call-template name="get-months-between">
			<xsl:with-param name="labyear" select="$lab-year"/>
			<xsl:with-param name="labmonth" select="$lab-month"/>
			<xsl:with-param name="currentyear" select="$current-year"/>
			<xsl:with-param name="currentmonth" select="$current-month"/>
		</xsl:call-template>
	</xsl:variable>

    <!-- TODO: SampleCCD.xml has only one organizer per entry. Is this a rule ? -->
    <xsl:variable name="order-name">
      <xsl:value-of select="$organizer-order/ORDER_NAME" />
    </xsl:variable>

    <xsl:variable name="code-name">
            <xsl:value-of select="$organizer-order/ORDER_CODE"/>
    </xsl:variable>

    <xsl:variable name="provider-name" >
        <xsl:call-template name="get-ordering-provider-name">
            <xsl:with-param name="name-tag" select="."/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="date-order">
        <xsl:call-template name="format-date">
            <xsl:with-param name="date" select="$organizer-order/RESULT_DATE"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="age-order">
        <xsl:choose>
            <xsl:when test="contains($organizer-order/RESULT_DATE,'.')">
                <xsl:call-template name="print-age">
                    <xsl:with-param name="first-date" select="substring-before($organizer-order/RESULT_DATE,'.')"/>
                    <xsl:with-param name="print-month" select="0"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="print-age">
                    <xsl:with-param name="first-date" select="$organizer-order/RESULT_DATE"/>
                    <xsl:with-param name="print-month" select="0"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="status">
      <xsl:value-of select="$organizer-order/STATUS"/>
    </xsl:variable>


    <xsl:variable name="comment-order">
      <xsl:value-of select="$organizer-order/COMMENTS"/>
    </xsl:variable>


    <xsl:variable name="source-order">
        <xsl:call-template name="translate-source">
            <xsl:with-param name="id-tag" select="$organizer-order/SOURCE"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />

    <xsl:if test="$statusUpCase != 'IN ERROR'">

        <xsl:if test="$summary = 1">
            <xsl:if test="$table = '6months'">
                <xsl:if test="$months-between &lt;= 6">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '1year'">
                <xsl:if test="$months-between &lt;= 12 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '18months'">
                <xsl:if test="$months-between &lt;= 18 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '2year'">
                <xsl:if test="$months-between &lt;= 24 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '3year'">
                <xsl:if test="$months-between &lt;= 48 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = 'all'">
                <tr code="{$code-name}">
                    <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                    <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                    <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                    <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                    <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$source-order"/></td>
                </tr>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$summary = 0">
            <xsl:if test="$table = '6months'">
                <xsl:if test="$months-between &lt;= 6">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$comment-order"/></td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '1year'">
                <xsl:if test="$months-between &lt;= 12 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$comment-order"/></td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '18months'">
                <xsl:if test="$months-between &lt;= 18 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$comment-order"/></td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '2year'">
                <xsl:if test="$months-between &lt;= 24 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$comment-order"/></td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = '3year'">
                <xsl:if test="$months-between &lt;= 48 and $months-between &gt;= 0">
                    <tr code="{$code-name}">
                        <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                        <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                        <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                        <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                        <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$comment-order"/></td>
                        <td width="{$cols/cols/col[position() = 6]/@width}%"><xsl:value-of select="$source-order"/></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$table = 'all'">
                <tr code="{$code-name}">
                    <td width="{$cols/cols/col[position() = 1]/@width}%"><xsl:value-of select="$order-name"/></td>
                    <td width="{$cols/cols/col[position() = 2]/@width}%"><xsl:value-of select="$provider-name"/></td>
                    <td width="{$cols/cols/col[position() = 3]/@width}%"><xsl:if test="$date-order!=''"><xsl:value-of select="$date-order"/>,<span><xsl:attribute name="class">dateAge</xsl:attribute>&#160;&#160;&#160;<xsl:value-of select="$age-order"/></span></xsl:if></td>
                    <td width="{$cols/cols/col[position() = 4]/@width}%"><xsl:value-of select="$status"/></td>
                    <td width="{$cols/cols/col[position() = 5]/@width}%"><xsl:value-of select="$comment-order"/></td>
                    <td width="{$cols/cols/col[position() = 6]/@width}%"><xsl:value-of select="$source-order"/></td>
                </tr>
            </xsl:if>
        </xsl:if>
    </xsl:if>

  </xsl:template>


  <xsl:template name="get-months-between">
	<xsl:param name="labyear" />
	<xsl:param name="labmonth" />
	<xsl:param name="currentyear" />
	<xsl:param name="currentmonth" />

	<xsl:variable name="year" select="$currentyear - $labyear"/>

	<xsl:choose>
		<xsl:when test="$currentmonth &lt; $labmonth">
			<xsl:value-of select="$year * 12 - ($labmonth - $currentmonth)"/>
		</xsl:when>
		<xsl:when test="$currentmonth &gt; $labmonth">
			<xsl:value-of select="$year * 12 + ($currentmonth - $labmonth)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$year * 12"/>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  
</xsl:stylesheet>
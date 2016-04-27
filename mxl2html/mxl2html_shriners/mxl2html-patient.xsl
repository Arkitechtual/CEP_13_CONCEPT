<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">
    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>


    <xsl:template name="patient-info">
        <xsl:param name="info"/>

        <table class="banner" border="0" width="100%">
            <tr>
                <td width="90%" align="center">

                    <xsl:call-template name="t-Name">
                        <xsl:with-param name="name" select="$info"/>
                    </xsl:call-template>
                    &#160;
                    <xsl:call-template name="t-Dob">
                        <xsl:with-param name="dob" select="$info/dob"/>
                    </xsl:call-template>
                    &#160;
                    <xsl:call-template name="t-Age">
                        <xsl:with-param name="age" select="$info/dob"/>
                    </xsl:call-template>
                    &#160;
                    <xsl:call-template name="t-Gender">
                        <xsl:with-param name="gender" select="$info/gender"/>
                    </xsl:call-template>
                    &#160;
                    <xsl:call-template name="t-CHRMRN">
                        <xsl:with-param name="info" select="$info"/>
                    </xsl:call-template>
                    &#160;
                </td>
                <td class="banner" align="right">
                    <div class="banner-button" onclick="toPrintALL()" id="printall-button">Print All</div>
                </td>
            </tr>
            <tr>
                <td width="90%" align="center">
                    <xsl:call-template name="t-DNRstatus"/>
                    &#160;
                    <xsl:call-template name="t-PCP">
                        <xsl:with-param name="provider" select="$info"/>
                    </xsl:call-template>
                    &#160;
                    <xsl:call-template name="t-homePhone">
                        <xsl:with-param name="home_phone" select="$info/phone"/>
                    </xsl:call-template>
                </td>
                <td align="right">
                    <div class="banner-button-columns" onclick="toSingleColumn()" id="single-column-button">Single column</div>
                    <div class="banner-button-columns" onclick="toDoubleColumn()" id="double-column-button" style="display:none">2 Columns</div>
                </td>
            </tr>

            <!--      WHAT IS IT?
           <span class="banner-smaller">
               <xsl:text>   </xsl:text>
               <a>
                   <xsl:attribute name="href"><xsl:value-of select="$root_context_path"/>/?<xsl:value-of
                           select="$encrypted_string"/>
                   </xsl:attribute>
                   Refresh
               </a>
               As of:
               <span id="banner-current-time"></span>
           </span> -->
        </table>
        <table class="desctable">
            <tr>
                <td>Disclaimer: This is an aggregate summary of medical information provided to this patient by Shriners Hospitals for Children.  It is provided to you in conformation with patient consent and privacy requirements.
                    <br/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <!-- [ Patient name ] -->
    <xsl:template name="t-Name">
        <xsl:param name="name"/>
        <span class="banner-bigger">
            <xsl:value-of select="$name/firstName"/><xsl:text> </xsl:text><xsl:value-of select="$name/middleName"/>
            <xsl:text> </xsl:text><xsl:value-of select="$name/lastName"/>
            <xsl:if test="$name/suffix != ''">
                <xsl:text>, </xsl:text><xsl:value-of select="$name/suffix"/>
            </xsl:if>
        </span>
    </xsl:template>

    <!-- [ Dob ] -->
    <xsl:template name="t-Dob">
        <xsl:param name="dob"/>
        <span class="banner-smaller">DOB:</span>
        <span class="banner-bigger">
            <!--<xsl:choose>
                <xsl:when test="$DATE_FORMAT='English'">
                    <xsl:value-of select="substring ($dob, 4, 2)"/>/<xsl:value-of select="substring ($dob, 1, 2)"/>/<xsl:value-of select="substring ($dob, 7, 4)"/>
                </xsl:when>
                <xsl:otherwise>  -->
                    <xsl:value-of select="$dob"/>
                <!--</xsl:otherwise>
            </xsl:choose>        -->
        </span>
    </xsl:template>

    <!-- [ Age] -->
    <xsl:template name="t-Age">
        <xsl:param name="age"/>
        <span class="banner-smaller">AGE:</span>
        <xsl:variable name="age2">
            <xsl:choose>
                <xsl:when test="$DATE_FORMAT='English'">
                    <xsl:value-of select="substring ($age, 4, 2)"/>/<xsl:value-of select="substring ($age, 1, 2)"/>/<xsl:value-of select="substring ($age, 7, 4)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$age"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span class="banner-bigger">
            <xsl:call-template name="print-age">
                <xsl:with-param name="first-date" select="$age2"/>
                <xsl:with-param name="print-month" select="0"/>
            </xsl:call-template>
        </span>
    </xsl:template>

    <!-- [ Gender ] -->
    <xsl:template name="t-Gender">
        <xsl:param name="gender"/>

        <span class="banner-smaller">GENDER:</span>
        <span class="banner-bigger">
            <xsl:choose>
                <xsl:when test='contains($gender, "M")'>
                    Male
                </xsl:when>
                <xsl:otherwise>
                    Female
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <!-- [ PCP ] -->
    <xsl:template name="t-PCP">
        <xsl:param name="provider"/>
        <span class="banner-smaller">PCP:</span>
        <span class="banner-bigger">
            <xsl:value-of select="$provider/pcp_first_name"/><xsl:text> </xsl:text><xsl:value-of select="$provider/pcp_middle_name"/>
            <xsl:text> </xsl:text><xsl:value-of select="$provider/pcp_last_name"/>
        </span>
    </xsl:template>

    <!-- [ CHR MRN ] -->
    <xsl:template name="t-CHRMRN">
        <xsl:param name="info"/>
        <span id="chr-mrn-container">
            <span class="banner-smaller">HIE ID:</span>
        </span>
        <div class="tooltip_link" style="display: inline">
            <span class="banner-bigger">
                <u>
                    <xsl:value-of select="$info/combinedId"/>
                </u>
            </span>
            <div class="tooltip" style="display:none">
                <div class="top"/>
                <div class="middle">
                    Source MRNs:
                    <br/>
                    <xsl:call-template name="get-bubble-mrn">
                        <xsl:with-param name="info" select="$info/patientIds"/>
                    </xsl:call-template>
                </div>
            </div>
        </div>

    </xsl:template>
    <xsl:template name="get-bubble-mrn">
        <xsl:param name="info"/>
        <xsl:for-each select="$info/patientId">
            <xsl:variable name="tmp">
                <xsl:call-template name="translate-source">
                    <xsl:with-param name="id-tag" select="./aa"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="./mrn"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space($tmp)"/>
            <br/>
        </xsl:for-each>
    </xsl:template>

    <!-- [ DNR Status ] -->
    <xsl:template name="t-DNRstatus">

        <span class="banner-smaller">DNR STATUS:</span>
        <span class="banner-bigger"></span>
    </xsl:template>

    <!-- [ Home Phone ] -->
    <xsl:template name="t-homePhone">
        <xsl:param name="home_phone"/>
        <span class="banner-smaller">Home Phone:</span>
        <span class="banner-bigger">
            <xsl:variable name="phoneDigits"
                                  select="translate($home_phone, translate($home_phone, '0123456789', ''), '')"/>
                    <xsl:value-of select="substring($phoneDigits,1,3)"/>-<xsl:value-of
                        select="substring($phoneDigits,4,3)"/>-<xsl:value-of select="substring($phoneDigits,7,4)"/>
        </span>
    </xsl:template>

</xsl:stylesheet>

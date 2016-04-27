<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-patient.xsl"/>
    <xsl:import href="mxl2html-sections-micro.xsl"/>
    <xsl:import href="mxl2html-sections-allergies.xsl"/>
    <xsl:import href="mxl2html-sections-encounters.xsl"/>
    <xsl:import href="mxl2html-sections-problems.xsl"/>
    <xsl:import href="mxl2html-sections-immunization.xsl"/>
    <xsl:import href="mxl2html-sections-vital-signs.xsl"/>
    <xsl:import href="mxl2html-sections-medications.xsl"/>
    <xsl:import href="mxl2html-sections-results.xsl"/>
    <xsl:import href="mxl2html-sections-labs.xsl"/>
    <xsl:import href="mxl2html-sections-labs-results.xsl"/>
    <xsl:import href="mxl2html-sections-vital-signs.xsl"/>
    <xsl:import href="mxl2html-sections-procedures.xsl"/>
    <xsl:import href="mxl2html-sections-diagnosis.xsl"/>
    <xsl:import href="mxl2html-tests.xsl"/>
    <xsl:import href="include-js.xsl"/>
    <xsl:import href="include-css.xsl"/>

    <xsl:param name="DATE_FORMAT"/>
    <xsl:param name="allow_medication"/>
    <xsl:param name="allow_immunization"/>
    <xsl:param name="allow_radiology"/>
    <xsl:param name="allow_other-reports"/>
    <xsl:param name="allow_history-physical"/>
    <xsl:param name="allow_anatomic-pathology"/>
    <xsl:param name="allow_Result-order"/>
    <xsl:param name="allow_discharge-summary"/>
    <xsl:param name="allow_micro"/>
    <xsl:param name="allow_vital"/>
    <xsl:param name="allow_lab_result"/>
    <xsl:param name="allow_Condition"/>
    <xsl:param name="allow_Diagnosis"/>
    <xsl:param name="allow_encounter"/>
    <xsl:param name="allow_procedure"/>
    <xsl:param name="allow_allergy"/>
    <xsl:param name="user_info"/>
    <xsl:param name="portal_info"/>
    <xsl:param name="caller"/>


    <xsl:output encoding="utf-8" indent="yes" method="html"/>

    <xsl:template match="/">
        <head>
            <meta http-equiv="x-ua-compatible" content="IE=edge"></meta>
        </head>
        <xsl:call-template name="build-css"/>

        <div>
            <xsl:call-template name="age-test-suite"/>

            <div id="wrap">
                <div id="nav">
                    <xsl:for-each select="./document/patient">
                        <xsl:call-template name="patient-info">
                            <xsl:with-param name="info" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </div>

                <xsl:call-template name="sections"/>

                <div id="footer">

                </div>
            </div>

        </div>

        <xsl:call-template name="build-js"/>

    </xsl:template>

    <xsl:template name="sections">

        <div id="print-area"/>
        <div id="content">
            <div id="page_wrapper">
                <table width="100%" class="main-table">
                    <tr>
                        <td class="main-table-td-left">

                            <xsl:if test="$allow_Condition = 'yes'">
                                <xsl:call-template name="build-section-problems">
                                    <xsl:with-param name="section" select="./document/problem[SUB_TYPE='Condition']"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_Diagnosis = 'yes'">
                                <xsl:call-template name="build-section-diagnosis">
                                    <xsl:with-param name="section" select="./document/problem[SUB_TYPE='Diagnosis']"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_procedure = 'yes'">
                                <xsl:call-template name="build-section-procedures">
                                    <xsl:with-param name="section" select="./document/procedure"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_medication = 'yes'">
                                <xsl:call-template name="build-section-medications">
                                    <xsl:with-param name="section" select="./document/medication"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_allergy = 'yes'">
                                <xsl:call-template name="build-section-allergies">
                                    <xsl:with-param name="section" select="./document/allergy"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_immunization = 'yes'">
                                <xsl:call-template name="build-section-immunization">
                                    <xsl:with-param name="section" select="./document/immunization"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_Result-order = 'yes'">
                                <xsl:call-template name="build-section-labs">
                                    <xsl:with-param name="organizer" select="./document/lab_result[SUB_TYPE='lab_result_order']"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_lab_result = 'yes'">
                                <xsl:call-template name="build-section-labs-results">
                                    <xsl:with-param name="organizer" select="./document/lab_result[SUB_TYPE='lab_result']"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_micro = 'yes'">
                                <xsl:call-template name="build-section-micro">
                                    <xsl:with-param name="organizer" select="./document/micro"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_anatomic-pathology = 'yes'">
                                <xsl:call-template name="build-section-results">
                                    <xsl:with-param name="organizer" select="./document/result[SUB_TYPE='anatomic-pathology']"/>
                                    <xsl:with-param name="organizer-type">anatomic-pathology</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>

                        </td>
                        <td class="main-table-td-right">

                            <xsl:if test="$allow_vital = 'yes'">
                                <xsl:call-template name="build-section-vital-signs">
                                    <xsl:with-param name="section" select="./document/vital"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_radiology = 'yes'">
                                <xsl:call-template name="build-section-results">
                                    <xsl:with-param name="organizer" select="./document/result[SUB_TYPE='radiology']"/>
                                    <xsl:with-param name="organizer-type">radiology</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_history-physical = 'yes'">
                                <xsl:call-template name="build-section-results">
                                    <xsl:with-param name="organizer" select="./document/result[SUB_TYPE='history-physical']"/>
                                    <xsl:with-param name="organizer-type">history-physical</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_discharge-summary = 'yes'">
                                <xsl:call-template name="build-section-results">
                                    <xsl:with-param name="organizer" select="./document/result[SUB_TYPE='discharge-summary']"/>
                                    <xsl:with-param name="organizer-type">discharge-summary</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_other-reports = 'yes'">
                                <xsl:call-template name="build-section-results">
                                    <xsl:with-param name="organizer" select="./document/result[SUB_TYPE='other-reports']"/>
                                    <xsl:with-param name="organizer-type">other-reports</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="$allow_encounter = 'yes'">
                                <xsl:call-template name="build-section-encounters">
                                    <xsl:with-param name="section" select="./document/encounter"/>
                                </xsl:call-template>
                            </xsl:if>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
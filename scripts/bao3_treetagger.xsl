<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8"/>
    <!-- Patrons à extraire
NOM PREP NOM PREP
VERBE DET NOM
NOM ADJ
ADJ NOM -->
    <xsl:template match="/">
        <xsl:text> Extraction du patron NOM+ADJ </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="//element" mode="extraction1"/>
        <xsl:text>
</xsl:text>
        <xsl:text>-----------------------</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text> Extraction du patron VERBE+DET+NOM</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="//element" mode="extraction2"/>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------------</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text> Extraction du patron NOM+PREP+NOM+PREP</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="//element" mode="extraction3"/>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------------</xsl:text>
        <xsl:text> Extraction du patron ADJ+NOM </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="//element" mode="extraction4"/>
        <xsl:text>
</xsl:text>
    </xsl:template>

    <!--- Patron : NOM+ADJ -->
    <xsl:template match="//element" mode="extraction1">
        <xsl:for-each select=".">
            <xsl:if test="(./data[starts-with(text(), 'NOM')])">
                <xsl:variable name="V1" select="./data[3]/text()"/>
                <xsl:if test="following-sibling::element[1][./data[starts-with(text(), 'ADJ')]]">
                    <xsl:variable name="V2" select="following-sibling::element[1]/data[3]/text()"/>
                    <xsl:value-of select="$V1"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$V2"/>
                    <xsl:text>
</xsl:text>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!---  V + DET + NOM -->
    <xsl:template match="//element" mode="extraction2">
        <xsl:for-each select=".">
            <xsl:if test="(./data[starts-with(text(), 'VER')])">
                <xsl:variable name="U1" select="./data[3]/text()"/>
                <xsl:if test="following-sibling::element[1][./data[starts-with(text(), 'DET')]]">
                    <xsl:variable name="U2" select="following-sibling::element[1]/data[3]/text()"/>
                    <xsl:if test="following-sibling::element[2][./data[starts-with(text(), 'NOM')]]">
                        <xsl:variable name="U3"
                            select="following-sibling::element[2]/data[3]/text()"/>
                        <xsl:value-of select="$U1"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$U2"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$U3"/>
                        <xsl:text>
</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <!---NOM+PREP+NOM+PREP -->

    <xsl:template match="//element" mode="extraction3">
        <xsl:for-each select=".">
            <xsl:if test="(./data[starts-with(text(), 'NOM')])">
                <xsl:variable name="P1" select="./data[3]/text()"/>
                <xsl:if test="following-sibling::element[1][./data[starts-with(text(), 'PRP')]]">
                    <xsl:variable name="P2" select="following-sibling::element[1]/data[3]/text()"/>
                    <xsl:if test="following-sibling::element[2][./data[starts-with(text(), 'NOM')]]">
                        <xsl:variable name="P3"
                            select="following-sibling::element[2]/data[3]/text()"/>
                        <xsl:if
                            test="following-sibling::element[3][./data[starts-with(text(), 'PRP')]]">
                            <xsl:variable name="P4"
                                select="following-sibling::element[3]/data[3]/text()"/>
                            <xsl:value-of select="$P1"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$P2"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$P3"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$P4"/>
                            <xsl:text>
</xsl:text>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>
    <!--- Patron : ADJ+NOM -->
    <xsl:template match="//element" mode="extraction4">
        <xsl:for-each select=".">
            <xsl:if test="(./data[starts-with(text(), 'ADJ')])">
                <xsl:variable name="V1" select="./data[3]/text()"/>
                <xsl:if test="following-sibling::element[1][./data[starts-with(text(), 'NOM')]]">
                    <xsl:variable name="V2" select="following-sibling::element[1]/data[3]/text()"/>
                    <xsl:value-of select="$V1"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$V2"/>
                    <xsl:text>
</xsl:text>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

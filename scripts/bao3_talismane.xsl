<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:text>(TITRE) Patron: NC ADJ : </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="/" mode="extraction1"/>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>(TITRE) Patron: DET NC ADJ : </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="/" mode="extraction2"/>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>(TITRE) Patron: DET ADJ NC V ADJ : </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="/" mode="extraction3"/>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>(DESC) Patron: NC ADJ : </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="/" mode="extraction4"/>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>(DESC) Patron: DET NC ADJ : </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="/" mode="extraction5"/>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>(DESC) Patron: DET ADJ NC V ADJ : </xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates select="/" mode="extraction6"/>
        <xsl:text>
</xsl:text>
        <xsl:text>------------------</xsl:text>
        <xsl:text>
</xsl:text>
    </xsl:template>
    <xsl:template match="/" mode="extraction1">
        <xsl:for-each select="//p">
            <xsl:if test="(./item[last()]/a[2] != '§')">
                <xsl:for-each select="./item">
                    <xsl:if test="(./a[4] = 'NC') and following-sibling::item[1]/a[4] = 'ADJ'">
                        <xsl:variable name="A" select="./a[2]"/>
                        <xsl:variable name="B" select="following-sibling::item[1]/a[2]"/>
                        <xsl:value-of select="$A"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$B"/>
                        <xsl:text>
</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/" mode="extraction2">
        <xsl:for-each select="//p">
            <xsl:if test="./item[1]/a[2]/text() != '§'">
                <xsl:for-each select="item">
                    <xsl:if test="./a[4] = 'DET'">
                        <xsl:variable name="DET" select="./a[2]/text()"/>
                        <xsl:if test="./following-sibling::item[1]/a[4]/text() = 'NC'">
                            <xsl:variable name="NOM"
                                select="./following-sibling::item[1]/a[2]/text()"/>
                            <xsl:if test="./following-sibling::item[2]/a[4]/text() = 'ADJ'">
                                <xsl:variable name="ADJ"
                                    select="./following-sibling::item[2]/a[2]/text()"/>
                                <xsl:value-of select="$DET"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$NOM"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$ADJ"/>
                                <xsl:text>
</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/" mode="extraction3">
        <xsl:for-each select="//p">
            <xsl:if test="./item[1]/a[2]/text() != '§'">
                <xsl:for-each select="item">
                    <xsl:if test="./a[4]/text() = 'DET'">
                        <xsl:variable name="DET" select="./a[2]/text()"/>
                        <xsl:if test="./following-sibling::item[1]/a[4]/text() = 'ADJ'">
                            <xsl:variable name="ADJ1"
                                select="./following-sibling::item[1]/a[2]/text()"/>
                            <xsl:if test="./following-sibling::item[2]/a[4]/text() = 'NC'">
                                <xsl:variable name="NOM"
                                    select="./following-sibling::item[2]/a[2]/text()"/>
                                <xsl:if test="./following-sibling::item[3]/a[4]/text() = 'V'">
                                    <xsl:variable name="VER"
                                        select="./following-sibling::item[3]/a[2]/text()"/>
                                    <xsl:if test="./following-sibling::item[4]/a[4]/text() = 'ADJ'">
                                        <xsl:variable name="ADJ2"
                                            select="./following-sibling::item[4]/a[2]/text()"/>
                                        <xsl:value-of select="$DET"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$ADJ1"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$NOM"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$VER"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$ADJ2"/>
                                        <xsl:text>
</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/" mode="extraction4">
        <xsl:for-each select="//p">
            <xsl:if test="(./item[last()]/a[2] = '§')">
                <xsl:for-each select="./item">
                    <xsl:if test="(./a[4] = 'NC') and following-sibling::item[1]/a[4] = 'ADJ'">
                        <xsl:variable name="A" select="./a[2]"/>
                        <xsl:variable name="B" select="following-sibling::item[1]/a[2]"/>
                        <xsl:value-of select="$A"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$B"/>
                        <xsl:text>
</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/" mode="extraction5">
        <xsl:for-each select="//p">
            <xsl:if test="./item[1]/a[2]/text() = '§'">
                <xsl:for-each select="item">
                    <xsl:if test="./a[4] = 'DET'">
                        <xsl:variable name="DET" select="./a[2]/text()"/>
                        <xsl:if test="./following-sibling::item[1]/a[4]/text() = 'NC'">
                            <xsl:variable name="NOM"
                                select="./following-sibling::item[1]/a[2]/text()"/>
                            <xsl:if test="./following-sibling::item[2]/a[4]/text() = 'ADJ'">
                                <xsl:variable name="ADJ"
                                    select="./following-sibling::item[2]/a[2]/text()"/>
                                <xsl:value-of select="$DET"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$NOM"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$ADJ"/>
                                <xsl:text>
</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/" mode="extraction6">
        <xsl:for-each select="//p">
            <xsl:if test="./item[1]/a[2]/text() = '§'">
                <xsl:for-each select="item">
                    <xsl:if test="./a[4]/text() = 'DET'">
                        <xsl:variable name="DET" select="./a[2]/text()"/>
                        <xsl:if test="./following-sibling::item[1]/a[4]/text() = 'ADJ'">
                            <xsl:variable name="ADJ1"
                                select="./following-sibling::item[1]/a[2]/text()"/>
                            <xsl:if test="./following-sibling::item[2]/a[4]/text() = 'NC'">
                                <xsl:variable name="NOM"
                                    select="./following-sibling::item[2]/a[2]/text()"/>
                                <xsl:if test="./following-sibling::item[3]/a[4]/text() = 'V'">
                                    <xsl:variable name="VER"
                                        select="./following-sibling::item[3]/a[2]/text()"/>
                                    <xsl:if test="./following-sibling::item[4]/a[4]/text() = 'ADJ'">
                                        <xsl:variable name="ADJ2"
                                            select="./following-sibling::item[4]/a[2]/text()"/>
                                        <xsl:value-of select="$DET"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$ADJ1"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$NOM"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$VER"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$ADJ2"/>
                                        <xsl:text>
</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

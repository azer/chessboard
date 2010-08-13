<?xml version="1.0" encoding="UTF-8"?>
  <xsl:stylesheet 
   version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" indent="yes"/> 

  <xsl:template name='square'>
    <xsl:param name="identifier"></xsl:param>
    <xsl:if test='contains("12345678rnbqkpRNBQKP",$identifier)'>
      <div class="square">
        <xsl:if test='not(contains("12345678",$identifier))'>
          <xsl:call-template name="piece">
            <xsl:with-param name="identifier" select="$identifier" />  
          </xsl:call-template>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name='piece'>
    <xsl:param name='identifier'>p</xsl:param>
    <xsl:variable name="name">
      <xsl:if test="contains('pP',$identifier)">pawn</xsl:if>
      <xsl:if test="contains('rR',$identifier)">rook</xsl:if>
      <xsl:if test="contains('nN',$identifier)">knight</xsl:if>
      <xsl:if test="contains('bB',$identifier)">bishop</xsl:if>
      <xsl:if test="contains('qQ',$identifier)">queen</xsl:if>
      <xsl:if test="contains('kK',$identifier)">king</xsl:if>
    </xsl:variable>
    <xsl:variable name="color">
      <xsl:choose>
        <xsl:when test='contains("rnbqkp",$identifier)'>white</xsl:when><xsl:otherwise>black</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <img class='piece'>
      <xsl:attribute name='data-name'>
        <xsl:value-of select="$name" />
      </xsl:attribute>
      <xsl:attribute name='data-color'>
        <xsl:value-of select="$color" />
      </xsl:attribute>
      <xsl:attribute name="src">
        <xsl:value-of select="/chessboard/set/url" />/<xsl:value-of select="$name" />_<xsl:value-of select="substring($color,1,1)" />.<xsl:value-of select="/chessboard/set/ext" />
      </xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template name="list-content">
    <xsl:param name="content">rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1</xsl:param>
    <xsl:param name="squareCounter">1</xsl:param>
    <xsl:param name="identifierCounter">1</xsl:param>
    <xsl:param name="charCounter">1</xsl:param>
    <xsl:variable name="identifier" select='substring($content,$charCounter,1)' />

    <xsl:call-template name="square">
      <xsl:with-param name="identifier" select="$identifier" />
    </xsl:call-template>
    
    <xsl:if test='contains("12345678",$identifier)'>
      <xsl:choose>
        <xsl:when test="$squareCounter - $identifierCounter=$identifier - 1">
          <xsl:call-template name="list-content">
            <xsl:with-param name="squareCounter" select="$squareCounter + 1" />  
            <xsl:with-param name="identifierCounter" select="$identifierCounter + $identifier" />
            <xsl:with-param name="charCounter" select="$charCounter + 1" />
            <xsl:with-param name="content" select="$content" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list-content">
            <xsl:with-param name="squareCounter" select="$squareCounter + 1" />  
            <xsl:with-param name="identifierCounter" select="$identifierCounter" />
            <xsl:with-param name="charCounter" select="$charCounter" />
            <xsl:with-param name="content" select="$content" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test='contains("rnbqkpRNBQKP",$identifier)'>
      <xsl:call-template name="list-content">
        <xsl:with-param name="squareCounter" select="$squareCounter + 1" />  
        <xsl:with-param name="identifierCounter" select="$identifierCounter + 1" />
        <xsl:with-param name="charCounter" select="$charCounter + 1" />
        <xsl:with-param name="content" select="$content" />
      </xsl:call-template>
    </xsl:if>

    <xsl:if test='contains("/",$identifier)'>
      <xsl:call-template name="list-content">
        <xsl:with-param name="squareCounter" select="$squareCounter" />  
        <xsl:with-param name="identifierCounter" select="$identifierCounter" />
        <xsl:with-param name="charCounter" select="$charCounter + 1" />
        <xsl:with-param name="content" select="$content" />
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template match='/chessboard'>
    <div class='chessboard'>
      <link rel='stylesheet' href='themes/default.css'></link>
      <div>
        <xsl:attribute name="class">
          chessboard
          <xsl:choose>
            <xsl:when test='perspective="w"'>
              perspective-white
            </xsl:when>
            <xsl:otherwise>
              perspective-black
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="list-content">
          <xsl:with-param name="content" select="/chessboard/fen" />  
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>

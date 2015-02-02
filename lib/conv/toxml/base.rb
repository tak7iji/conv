# coding: utf-8

require 'nokogiri'
require 'csv'
require 'cgi'
require 'roo'
require 'conv/headers'

module Conv
  module ToXml
    class Base

    def initialize argv
      @argv = argv
      @ext_name = File.extname(argv[:f])
      @base_name = File.basename(argv[:f], @ext_name).encode(Encoding::UTF_8)
    end

    # ユーティリティメソッド定義
    def createCategory options
      id = options[:id]
      name = options[:name]
  
      @root.xpath('//xmlns:CategoryList')[0].add_child(<<-"EOL")
      <Category categoryId='category_#{id}' appropriate='true'>
          <CategoryName>#{name}</CategoryName>
      </Category>
      EOL
      "category_#{id}"
    end

    def createSearchInfo line, options
      id = options[:id]
      fileType = line[Conv::FILE_TYPE]||''
      key1 = CGI::escape_html(line[Conv::KEYWORD_1]||'')
      key2 = CGI::escape_html(line[Conv::KEYWORD_2]||'')
      py_mod = line[Conv::MODULE]||''
      todo = line[Conv::TODO]
      line_num = exist?(todo) ? (line[Conv::LINE_NUM]||'').to_i : todo
      reason = line[Conv::LINE_NUM_CONTENTS]||''
      invest = line[Conv::INVEST]||''
      calc = (line[Conv::LINE_NUM_APPROPRIATE]||'false').downcase
      contents = line[Conv::APPROPRIATE_CONTENTS]||''
  
      @root.xpath('//xmlns:SearchInfomationList')[0].add_child(<<-"EOL")
      <SearchInfomation searchInfoId="#{id}">
          <FileType>#{fileType}</FileType>
          <SearchKey1>#{key1}</SearchKey1>
          <SearchKey2>#{key2}</SearchKey2>
          <PythonModule>#{py_mod}</PythonModule>
          <LineNumberInfomation>
              <LineNumber>#{line_num}</LineNumber>
              <LineNumberContents>#{reason}</LineNumberContents>
              <Investigation>#{invest}</Investigation>
          </LineNumberInfomation>
          <Appropriate lineNumberAppropriate='#{calc}'>
              <AppropriateContents>#{contents}</AppropriateContents>
          </Appropriate>
      </SearchInfomation>
      EOL
    end
  
    def createDocBook options
      id = options[:id]
      title = options[:title]
      detail = options[:detail]
  
      @root.xpath('//xmlns:DocBookList')[0].add_child(<<-"EOL")
      <DocBook articleId="knowhowDetail_#{id}">
          <ns3:article>
              <ns3:info>
                  <ns3:title>#{title}</ns3:title>
              </ns3:info>
              <ns3:section>#{detail}</ns3:section>
          </ns3:article>
      </DocBook>
      EOL
    end

    def createEntry node, options
      category = options[:category]
      cat_id = options[:cat_id]
  
      node.add_child(<<-"EOL")
      <#{category}>
          <EntryCategoryRefKey>#{cat_id}</EntryCategoryRefKey>
      </#{category}>
      EOL
    end
  
    def addChildEntry list
      list.each do |cat|
        parCatId = @root.xpath("//xmlns:Category[xmlns:CategoryName/text()='#{cat[1]}']").attr('categoryId')
        ns = @root.xpath("//xmlns:EntryCategoryRefKey[text()='#{parCatId}']")[0]
        createEntry(ns.parent, :category => 'ChildEntry', :cat_id => cat[0]) if ! ns.nil?
      end
    end

    def registKnowhowRef options
      key  = options[:key]
    
      @root.xpath("//xmlns:CategoryName[text()='#{options[:name]}']")[0].after(<<-"EOL")
      <KnowhowRefKey>#{key}</KnowhowRefKey>
      EOL
    end

    def createKnowhowInfo options
      id = options[:id]
      key = options[:key]
      name = options[:name]
  
      @root.xpath('//xmlns:KnowhowList')[0].add_child(<<-"EOL")
      <KnowhowInfomation knowhowId='knowhow_#{id}' knowhowDetailRefKey='#{key}'>
          <KnowhowNo>1</KnowhowNo>
          <KnowhowName>#{name}</KnowhowName>
      </KnowhowInfomation>
      EOL
    end
  
    def registCheckItem line, options
      id = options[:id]
      name = line[Conv::CHECK_ITEM_NAME]||''
      process = line[Conv::SEARCH_PROCESS]||''
      exist = (line[Conv::SEARCH_EXIST]||'false').downcase
      factor = line[Conv::FACTOR]||''
      degree = line[Conv::DEGREE]||''
      detail = line[Conv::DEGREE_DETAIL]||''
      vcon = line[Conv::VISUAL_CONFIRM]||''
      hcon = line[Conv::HEARING_CONFIRM]||''
      ftype = line[Conv::FILE_TYPE]
      item_no = @root.xpath("//xmlns:KnowhowInfomation[@knowhowDetailRefKey='#{options[:key]}']/xmlns:CheckItem").length + 1
  
      ref_key = "searchInfo_#{@root.xpath('//xmlns:SearchInfomation').length+1}" if ! exist?(ftype)
      ref_key_attr = "searchRefKey='#{ref_key}'" if ! exist?(ref_key)
  
      @root.xpath("//xmlns:KnowhowInfomation[@knowhowDetailRefKey='#{options[:key]}']")[0].add_child(<<-"EOL")
      <CheckItem checkItemId='checkItem_#{id}' #{ref_key_attr} searchExistance='#{exist}'>
          <CheckItemNo>#{item_no}</CheckItemNo>
          <CheckItemName>#{name}</CheckItemName>
          <SearchProcess>#{process}</SearchProcess>
          <PortabilityFactor>#{factor}</PortabilityFactor>
          <PortabilityDegree>#{degree}</PortabilityDegree>
          <DegreeDetail>#{detail}</DegreeDetail>
          <VisualConfirm>#{vcon}</VisualConfirm>
          <HearingConfirm>#{hcon}</HearingConfirm>
      </CheckItem>
      EOL
  
      # SearchInformationList作成
      createSearchInfo(line, :id => ref_key) if ! exist?(ftype)
    end

    def addChildChapter node, id, ref
      node.add_child(<<-"EOL")
      <ChildChapter>
          <ChildCapterNo>#{id}</ChildCapterNo>
          <ChapterCategoryRefKey>#{ref}</ChapterCategoryRefKey>
      </ChildChapter>
      EOL
    end
  
    def createChapter options
      id = options[:id]
      name = options[:name]
      cat_ref = options[:cat_ref]
  
      @root.xpath('//xmlns:ChapterList')[0].add_child(<<-"EOL") if @root.xpath("//xmlns:ChapterName[text()='#{name}']").empty?
      <Chapter>
          <ChapterNo>#{id}.</ChapterNo>
          <ChapterName>#{name}</ChapterName>
      </Chapter>
      EOL
  
      chap = @root.xpath("//xmlns:Chapter/xmlns:ChapterNo[following-sibling::xmlns:ChapterName/text()='#{name}']")[0]
      child_id = "#{chap.text}#{chap.parent.xpath('ChildChapter').length + 1}."
      addChildChapter chap.parent, child_id, cat_ref
    end

    def registChildChapter node
      node.each do |e|
        par_ref = e.parent.xpath('xmlns:EntryCategoryRefKey').text
        par = @root.xpath("//xmlns:ChildChapter/xmlns:ChildCapterNo[following-sibling::xmlns:ChapterCategoryRefKey/text()='#{par_ref}']")[0]
        cat_ref = e.xpath("xmlns:EntryCategoryRefKey").text

        child_id = "#{par.text}#{par.parent.xpath('xmlns:ChildChapter').length + 1}."
        addChildChapter par.parent, child_id, cat_ref
    
       registChildChapter node.xpath("xmlns:ChildEntry[preceding-sibling::xmlns:EntryCategoryRefKey/text()='#{cat_ref}']")
      end
    end

    def exist? target
      target.nil? || target.empty?
    end
  
    def process
      # 処理本体
      cat_id=0
      search_id=0
      book_id=0
      knowhow_id=0
      item_id=0
      chapter_id=0
      cat_list = Array.new
      portability_knowhow_title = nil

      proc = lambda do |line|

        metadata = false
        chapter_no = line[Conv::NO]
        if chapter_no[0, 2] == "@@" then
          portability_knowhow_title = chapter_no[2..-1]
          metadata = true
        end

        next if chapter_no == NO || metadata
  
        cat_name = line[Conv::CATEGORY_NAME]
        parent_cat_name = line[Conv::PARENT_CATEGORY_NAME]
        knowledge_detail = line[Conv::KNOWLEDGE_DETAIL]
        knowledge_title = line[Conv::KNOWLEDGE_TITLE]
        check_item_name = line[Conv::CHECK_ITEM_NAME]
        chapter_name = line[Conv::CHAPTER_NAME]
  
        # CategoryList作成
        cat_ref = createCategory(:id => cat_id+=1, :name => cat_name) if @root.xpath("//xmlns:CategoryName[text()='#{cat_name}']").empty?
  
        # DocBookList作成
        detail = (!exist?(knowledge_detail) && !knowledge_detail.strip.start_with?("<")) ? knowledge_detail.split(/\n/).map{|e| "<ns3:para>#{CGI::escape_html(e)}</ns3:para>"}.join("\n") : knowledge_detail
        createDocBook(:id => book_id+=1, :title => knowledge_title, :detail => detail||'') if @root.xpath("//xmlns:DocBook[descendant::ns3:title/text()='#{knowledge_title}']").empty? && ! exist?(knowledge_title)

        # KnowhowRef登録
        registKnowhowRef(:name => cat_name, :key => "knowhow_#{book_id}") if @root.xpath("//xmlns:KnowhowRefKey[text()='knowhow_#{book_id}']").empty? && ! exist?(knowledge_title)
  
        # KnohowList作成
        articleId = @root.xpath("//xmlns:DocBook[descendant::ns3:title/text()='#{knowledge_title}']/@articleId")
        createKnowhowInfo(:id => knowhow_id+=1, :key => articleId, :name => knowledge_title) if @root.xpath("//xmlns:KnowhowName[text()='#{knowledge_title}']").empty? && ! exist?(knowledge_title) && ! articleId.nil?

        # CheckItem登録
        registCheckItem(line, :id => item_id+=1, :key => articleId) if ! exist?(knowledge_title) && ! exist?(check_item_name) && ! articleId.nil?
  
        # Chapter登録（その１）
        chapter_id+=1 if @root.xpath("//xmlns:ChapterName[text()='#{chapter_name}']").empty? && ! exist?(chapter_name) && ! cat_ref.nil?
        createChapter(:id => chapter_id, :name => chapter_name, :cat_ref => cat_ref) if ! exist?(chapter_name) && ! cat_ref.nil?
  
        cat_list << [cat_ref, parent_cat_name] if ! cat_ref.nil?
      end
  
      # XMLビルダー
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.PortabilityKnowhow('xmlns' => 'http://generated.model.biz.knowhow.tubame/knowhow', 'xmlns:ns2' => 'http://www.w3.org/1999/xlink', 'xmlns:ns3' => 'http://docbook.org/ns/docbook') {
          xml.PortabilityKnowhowTitle
          xml.EntryViewList
          xml.ChapterList
          xml.CategoryList
          xml.KnowhowList
          xml.DocBookList
          xml.SearchInfomationList
        }
      end
      @root = builder.doc

      case @ext_name
      when ".csv"
        CSV.foreach(@argv[:f], {:encoding => 'Shift_JIS:UTF-8', :headers => Conv::HEADERS, :return_headers => false}, &proc)
      when ".xlsx"
        # 第二引数にシート名が指定されている場合は、そのシートから読み込む
        Roo::Excelx.new(@argv[:f]).tap{|s| s.default_sheet=@argv[:s] if !@argv[:s].nil?}.each({:headers => true}, &proc)
      else
        puts "#{@ext_name} is not supported file format."
        exit
      end
  
      cat_list.uniq!
  
      # EntryViewList作成（その１）
      # トップレベルエントリだけ作成
      ns = @root.xpath('//xmlns:EntryViewList')[0]
      cat_list.select{|e| exist?(e[1])}.each do |line|
        createEntry(ns, :category => 'EntryCategory', :cat_id => line[0]) if @root.xpath("//xmlns:EntryCategoryRefKey[text()='#{line[0]}']").empty?
      end
  
      # EntryViewList作成（その２）
      # 子エントリ作成
      addChildEntry cat_list.select{|e| !exist?(e[1])}
  
      # ChildChapter登録（その２）
      registChildChapter @root.xpath('//xmlns:EntryViewList/xmlns:EntryCategory/xmlns:ChildEntry')

      # PortabilityKnowhowTitle設定
      @root.xpath("//xmlns:PortabilityKnowhowTitle")[0].content = portability_knowhow_title
  
      # XML出力
      FileUtils.mkdir @argv[:o] if ! @argv[:o].nil? && ! File.exists?(@argv[:o])
      output_file = "#{@argv[:o]+'/' if ! @argv[:o].nil? && Dir.exists?(@argv[:o])}#{@base_name}.xml"

      File.open(output_file, "w") {|file| file.write(@root.to_xml) }
    end
    end
  end
end
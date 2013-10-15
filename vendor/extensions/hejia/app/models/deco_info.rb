# == Schema Information
#
# Table name: HEJIA_COMPANY
#
#  ID                     :integer(11)     not null, primary key
#  CN_NAME                :string(255)
#  EN_NAME                :string(255)
#  COMPANY_TYPE           :integer(11)
#  SECTION                :string(255)
#  WEB_SITE               :string(255)
#  ADDRESS                :string(255)
#  POSTCODE               :string(255)
#  EMAIL                  :string(255)
#  FAX                    :string(255)
#  TEL                    :string(255)
#  CHECK_COMPANY_NO       :string(255)
#  CONTACTOR              :string(255)
#  DESCRIBE               :text
#  PARENTID               :integer(11)
#  COMPANY_PP             :integer(11)
#  COMPANY_SCOPE          :integer(11)
#  USER_ID                :integer(11)
#  TOTAL_MONEY            :integer(11)
#  USED_MONEY             :integer(11)
#  REMAIN_MONEY           :integer(11)
#  SERVICE                :text
#  LOGINNAME              :string(255)
#  PASSWARD               :string(255)
#  CONTRACT               :string(10)
#  ENDDATE                :date
#  CREATEDATE             :date
#  WEBSTAGE               :string(255)
#  LINKMAN                :string(255)
#  ENDBUSINESS            :string(255)
#  BEGINBUSINESS          :string(255)
#  COUNTRY                :string(255)
#  AREA                   :string(245)
#  TYPE                   :string(255)
#  CODE                   :string(255)
#  ATTRIBUTE              :string(255)
#  COMSIZE                :string(255)
#  STATUS                 :string(255)
#  CONTRACTID             :integer(11)
#  HASORDERMANAGERFEATURE :integer(11)
#  HASCHATMANAGERFEATURE  :integer(11)
#  ONLINETIME             :integer(11)
#  SUBCOMPANYS            :string(255)
#  COMPANYLOGO            :string(255)
#  COMPANYTYPE            :string(255)
#  SI_NAME                :string(510)
#  ADVERTISEID            :integer(11)
#  COMPANYTAGS            :string(255)
#  ADVERTISE              :string(255)
#  EXAMINEADDRESS         :string(255)
#  STARCLASS              :integer(10)
#  SALETITLE              :string(510)
#  MOBELTELEPHONE         :string(510)
#  HEADPIC                :string(510)
#  ORDERID                :integer(10)
#  NOTE                   :string(510)
#  BRAND                  :string(510)
#  HOTSALE                :string(510)
#  SCOPE                  :string(510)
#  PRICELISTINFO          :text
#  PHONE                  :string(510)
#  ANSWERPHONE1           :string(510)
#  ANSWERPHONE2           :string(510)
#  ANSWERPHONE3           :string(510)
#  PHONECUT               :string(510)
#  SALESMAN               :string(510)
#  COMPANYCODE            :string(510)
#  SERVICECLOSETIME       :string(510)
#  SERVICESTARTTIME       :string(510)
#  COMPANYSHORTNAME       :string(510)
#  RANDOMPV               :integer(11)
#  THROUGH                :string(510)
#  NEEDRECHECKED          :integer(10)
#  SALESMANID             :integer(11)
#  PAGETYPE               :string(510)
#  SPECIAL                :integer(11)
#  QQ                     :string(510)
#  MSN                    :string(510)
#  MARKETID               :integer(11)
#  SERVICELEVEL           :string(510)
#  GUILDID                :string(510)
#  PEIHELEVEL             :string(510)
#  OPBEGINTIME            :datetime
#  OPENDTIME              :datetime
#  ERRORDESCRIPTION       :string(510)
#  MERCHANT               :string(510)
#  STRGONGDI              :text
#  ASKNAME                :string(510)
#  ASKURL                 :string(510)
#  JIANGTANGURL           :string(510)
#  COMPANYPAY             :integer(11)
#  NEWZHUANGXIUGONGSI     :string(255)
#  MOBANPATH              :string(255)
#  COMPANYCREATEDATE      :string(255)
#  POINT                  :string(255)
#  PRICEMETOD             :string(255)
#  ZHUANGXIUMETHOD        :string(255)
#  GOODSTYLE              :string(255)
#  TEMPLATEPATH           :string(255)
#  COMPANYCITY            :integer(11)
#  COMPANYAREA            :integer(11)
#  COMPANYSPECIAL         :string(255)
#  DIQU                   :string(255)
#  PRODUCTDEALNUM         :integer(10)
#  DESIGNABILITY          :integer(11)
#  BUGETREQNSONALITY      :integer(11)
#  CONSTRACTQUALITY       :integer(11)
#  AFTERSERVICE           :integer(11)
#  TELCOUNT               :integer(11)
#  PPZMD                  :integer(10)
#  JGCXD                  :integer(10)
#  SHFUD                  :integer(10)
#  primary_vantag         :integer(11)
#  primary_style          :integer(11)
#  confirm                :integer(11)     default(0)
#

# -*- coding: utf-8 -*-
class DecoInfo < Hejia::Db::Hejia
  self.table_name = "HEJIA_COMPANY"
  self.primary_key = "ID"


  validates_presence_of  :CN_NAME, :message => "公司名称不能为空"
  validates_presence_of  :ADDRESS, :message => "地址不能为空"
  validates_presence_of  :EMAIL, :message => "邮箱不能为空"
  validates_presence_of  :TEL, :message => "电话不能为空"
  validates_presence_of  :MOBELTELEPHONE, :message => "手机不能为空"
  validates_presence_of  :COMPANYCITY, :message => "城市位置不能为空"
  validates_presence_of  :COMPANYAREA, :message => "城市区域不能为空"
  validates_format_of :EMAIL, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "邮件格式不正确"


  has_and_belongs_to_many :odd_hejia_tag,
  :join_table => "51hejia.HEJIA_TAG_ENTITY_LINK",
  :foreign_key => "ENTITYID",
  :association_foreign_key => "TAGID",
  :conditions =>["51hejia.HEJIA_TAG_ENTITY_LINK.LINKTYPE = 'deco_company'"]
end

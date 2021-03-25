----单行函数：作用于一行，返回一个值。

--字符函数
/*
concat(char1,char2)：将char1与char2合并

upper(char)：将字符串char中所有字母转为大写
lower(char)：将字符串中所有字母转为小写
initcap(char)：将字符串中的每个单词的首字母转为大写

nls_upper(char[,'NLS_SORT = 排序类型'])：将字符串char中所有字母按排序类型要求转为大写
nls_lower(char[,'NLS_SORT = 排序类型'])：将字符串char中所有字母按排序类型要求转为小写：
nls_initcap(char[,'NLS_SORT = 排序类型'])：将字符串char中所有单词的字母排序类型要求转为大写：

chr(n)：将n数值作为参数返回一个字符(不同的机器，数据库定义的字符集不一样，返回的字符就不一样)
nchr(n)：将n数值作为参数返回一个字符。等效于chr (n using nchar_cs)

lpad(expr1,n,expr2)：在expr1左边填充expr2使整个字段长度为n,如果expr1长度大于n,将从右边截断。
rpad(expr1,n,expr2)：在expr1右边填充expr2使整个字段长度为n,如果expr1长度大于n,将从右边截断。

trim(【[leading|trailing|both] substr from 】str)：从str的[头|尾|两头]删除substr，【】里的内容不填写，默认删除两头空格
ltrim(str,set)：将str左侧中所有的set中包含的去除。
rtrim(str,set)：将str右侧中所有的set中包含的去除。

substr(str,position,substring_length)：将str中，从position开始的，substring_length长的字符返回。
      substr：使用输入的字符集定义的字符来计算长度
      substrb：使用bytes
      substrc：使用unicode完全字符
      substr2：使用ucs2编码
      substr4：使用ucs4编码
regexp_substr(source_char,pattern[,position,occurrence,match_param,subexpr])：返回source_char中满足pattern的第subexpr个表达式
           后匹配了match_param的，第position位开始，第occurrence次出现的子字符串。
    __source_char：需要进行正则处理的字符串
    __pattern：进行匹配的正则表达式
    __position：正整数，指示source_char中的起始位置，从第几个字符开始正则表达式匹配（默认为1）
    __occurrence：正整数，指示pattern应该从source_char中的第几个匹配位置，从第几个匹配项开始正则表达式匹配（默认为1）
    __match_param：匹配模式（
                   'i'不区分大小写进行检索;
                   'c'区分大小写进行检索。默认为'c';
                   'n'允许匹配任何字符的字符(.)来匹配换行符，如果省略则不匹配换行符;
                   'm'将源字符串视为多行，oracle会插入^$表示源字符串的任何行的开始与结尾;
                   'x'忽略空格字符，默认情况下，空格字符会相互匹配）
    __subexpr：0-9的非负整数，指示上面的正则表达式返回哪个子表达式。

nlssort(char[,'nlsparam'])：将char按显式或隐式指定的比较排序规则nlsparam比较排序后返回。
   'nlsparam' 的值必须具有形式 'NLS_SORT = collation'
nls_sort：nls_sort = { binary | linguistic_definition}
  拼音:schinese_pinyin_m
  笔划:schinese_stroke_m
  部首:schinese_radical_m
  
  通过以下代码可以查看nls_sort可以用的取值
      select parameter,
             value
      from   v$nls_valid_values
      where  parameter =
             'SORT'
      order  by value;
  查看当前数据库的参数
      select parameter,
             value
      from   nls_database_parameters;
  查看当前会话的参数
      select parameter,
             value
      from   nls_session_parameters;
      
replace(str,seach_string[,replacement_string])：将str中的所有seach_string替换为replacement_string，如果replacement_string省
             略或者为空，则将str中的所有seach_string删除，如果seach_string为空，则返回str。

regexp_replace(source_char,pattern[,replace_string,position,occurrence,match_param])：将source_char中满足pattern的字符匹
             配match_param后，从第position位开始，第occurrence次的替换为replace_string
    __source_char：需要进行正则替换处理的字符串
    __pattern：进行匹配的正则表达式
    __replace_string：将满足正则匹配之后字符替换为replace_string
    __position：正整数，指示source_char中的起始位置，从第几个字符开始正则表达式匹配（默认为1）
    __occurrence：正整数，指示pattern应该从source_char中的第几个匹配位置，从第几个匹配项开始正则表达式匹配（默认为1）
    __match_param：匹配模式（
                   'i'不区分大小写进行检索;
                   'c'区分大小写进行检索。默认为'c';
                   'n'允许匹配任何字符的字符(.)来匹配换行符，如果省略则不匹配换行符;
                   'm'将源字符串视为多行，oracle会插入^$表示源字符串的任何行的开始与结尾;
                   'x'忽略空格字符，默认情况下，空格字符会相互匹配）

soundex(char)：将发音跟char相似的单词返回

translate(expr,from_string,to_string)：将expr中的所有from_string替换为to_string,注意：from_string与to_string中的依次对应。
translate(char using char_cs|nchar_cs)：将char转换为数据库字符集char_cs|民族字符集nchar_cs
*/
SELECT translate（ 'SQL*Plus \User''s Guide' ， '* ''\' ， '+-%$#@' ）from dual;

SELECT regexp_substr(' 500 ORACLE PARKWAY,REDWOOD SHORES,CA ', ',[ ^,] +,') "REGEXPR_SUBSTR"from dual;

SELECT ltrim(' <= == == > BROWNING <= == == > ', ' <> = ') "LTRIM Example" FROM dual;

SELECT rtrim(' <= == == > BROWNING <= == == > ', ' <> = ') "LTRIM Example" FROM dual;

/*
ltrim example
---------------
browning<=====>
*/

SELECT REPLACE(' JACK AND JUE ', ' J ', ' BL ') "Changes" FROM dual;

SELECT concat(' HELLO ', ' WORLD ') FROM dual;

SELECT upper(' YES ') FROM dual; --输出yes

SELECT lower(' YES ') FROM dual; --输出yes

SELECT initcap(' YES YOU ARE A GOOD MAN ') FROM dual; --输出yes

SELECT nls_lower(' LIVE OIL ', ' NLS_SORT = XTURKISH ') "Lowercase" FROM dual;

SELECT chr(41378) FROM dual;

--返回数值的字符函数
/*
ascii(char)：ascii返回char的第一个字符在数据库字符集中的十进制表示数值。
instr(string,substring[,position,occurrence])：在string中从第position位开始，找出substring第occurrence次出现的位置索引。
       instr：使用输入的字符集定义的字符来计算长度
       instrb：使用bytes
       instrc：使用unicode完全字符
       instr2：使用ucs2编码
       instr4：使用ucs4编码

length(char)：返回char的长度
       length：使用输入的字符集定义的字符来计算长度
       lengthb：使用bytes
       lengthc：使用unicode完全字符
       length2：使用ucs2编码
       length4：使用ucs4编码

regexp_count(source_char,pattern[,position,match_param])：返回满足pattern的字符匹配match_param后在source_char中
       从第position位起出现的次数

regexp_instr(source_char,pattern[,position,occurrence,return_opt(0|1),subexpr])：返回满足pattern的第subexpr个表达式后的字符,
       在source_char中第position位开始，第occurrence[+0|+1]次出现的位置索引。
*/

SELECT regexp_instr('500 Oracle Parkway, Redwood Shores, CA', '[^ ]+', 1, 6, 1) "REGEXP_INSTR"
FROM   dual;

SELECT ascii('a') FROM dual; --97

SELECT instr('cvabcabcabc', 'abc', 1, 2) FROM dual;

--字符集函数——返回字符设置的信息
/*
nls_charset_decl_len(byte_count,char_set_id)：返回一个nchar列声明的长度(字符数),byte_count是列的宽度。
       char_set_id是该列的字符集id。
nls_charset_id(string)：返回与字符集名称string对应的字符集id号。

nls_charset_name(number)：返回与字符集idnumber对应的字符集名称。

*/
SELECT nls_charset_id('US7ASCII') FROM dual; --1

SELECT nls_charset_name(1) FROM dual; --us7ascii

--排序函数——返回排序设置的有关信息【12c版本新增】
/*
collation(expr)：返回expr的派生排序规则的名称。
nls_collation_id(expr)：将排序规则的名称作为参数expr,返回对应的排序规则id号。
nls_collation_name(expr[,flag])：将排序规则的id号作为参数expr,返回对应的排序规则名称。
       可选参数flag可以为s|s 返回归类名称的缩写形式，l|l 返回归类名称的长格式。
*/

SELECT nls_collation_name(81919) FROM dual;

CREATE TABLE id_table("NAME" VARCHAR2(64), "ID" VARCHAR2(8));

INSERT INTO id_table VALUES ('Christopher', 'ABCD1234');

SELECT collation(NAME), collation(id) FROM id_table;

--数值函数
/*
abs(n)：返回n的绝对值

mod(n2,n1)：返回n2/n1的余数。向下取整取模。如果n1是0返回n2
remainder(n2,n1)：返回n2/n1的余数。四舍五入取模。并且n1不能是0。

ceil(n)：返回>=n的最小整数，向上取整
floor(n)：返回<=n的最大整数，向下取整
round(n[,integer])：返回n保留integer位小数后四舍五入的值。如果integer为负，则n四舍五入到小数点左边。默认整数位四舍五入。
trunc(n1[,n2])：返回n1截断小数点n2位后的值。如果n2为负，就将小数点后面的全截断，并将小数点前-n2位设置为0。

power(n2,n1)：返回n2的n1次方。n1,n2可以是任何数。但如果n2是负数，那么n1必须是整数。
sqrt(n)：返回n的平方根。当n是数值型：n不能为负数，返回实数。如果n是二进制浮点型：当n>=0,结果为正;当n=-0,结果为-0;当n<0,结
        果为nan
sign(n)：返回n的符号。n为数值类型时：n>0,返回1;n=0,返回0;n<0,返回-1;n为二进制浮点数时：n<0,返回-1;n>=0 或 n=nan,返回1

acos(n)：返回n的反余弦值。参数必须是-1到1之间。并且该函数返回值在0 - pi之间(以弧度表示)
asin(n)：返回n的反正弦值。参数必须是-1到1之间。并且该函数返回值-pi/2 - pi/2之间(以弧度表示)
atan(n)：返回n的反正切值。参数无范围限制，该函数返回值-pi/2 - pi/2之间(以弧度表示)
atan2(n1,n2)：返回n1,n2的反正切值。参数n1无范围限制，该函数返回值-pi - pi之间，取决于n1,n2的符号(以弧度表示)
cos(n)：返回n的余弦值(以弧度表示)。
cosh(n)：返回n的双曲余弦值(以弧度表示)。
sin(n)：返回n的正弦值(以弧度表示)。
sinh(n)：返回n的双曲正弦值(以弧度表示)。
tan(n)：返回n的正切值(以弧度表示)。
tanh(n)：返回n的双曲正切值(以弧度表示)。

bitand(expr1,expr2)：返回expr1跟expr2的位与运算。
exp(n)：返回e的n次方。e=2.71828182845904523536028747135266249776
ln(n)：返回n的自然数对数。其中n>0。
log(n2,n1)：返回n1以n2为底的对数
nanvl(n2,n1)：仅适用于binary_float或binary_double类型的浮点数。如果n2是nan(不是一个数),就返回n1,如果n2不是nan，就返回n2。
width_bucket(expr,min_value,max_value,num_buckets)：为expr创建最小值为min_value，最大值为max_value,桶的数量为num_buckets
        的等宽直方图，
*/

--日期函数
/*
add_months(date,integer)：返回date加上integer个月后的日期。
current_date：返回当前会话时区中的当前日期;
current_timestamp[(precision)]：以带时区的时间戳数据类型返回当前会话时区的日期时间。
localtimestamp[(timestamp_precision)]：以时间戳数据类型返回当前会话时区的日期时间。
systimestamp：返回数据库所在系统的系统日期，包括小数秒和时区的时间戳。
dbtimezone：返回数据库的时区;
extract(year|month|day|hour|minute|second|timezone_hour|timezone_minute|timezone_region|timezone_abbr from expr)：从日期时间
        或间隔表达式中提取并返回指定的日期时间字段的值。

from_tz(timestamp_value, time_zone_value)：将时间戳类型的日期和字符串类型的时区转换为带时区的时间戳。
last_day(date)：返回包含date的月份的最后一天的日期时间。

months_between(date1, date2)：返回date1与date2之间有几个月。

new_time(date, timezone1, timezone2)：返回在timezone1时区的date在timezone2时区的日期时间。
next_day(date, char)：返回在日期date后第一工作日为星期char的日期。

numtodsinterval(n, 'interval_unit')：将数值n换算为以interval_unit为单位的时间文字。interval_unit可以是：day|hour|minute|second
numtoyminterval(n, 'interval_unit')：将数值n换算为以interval_unit为单位的时间文字。interval_unit可以是：year|month
ora_dst_affected(datetime_expr)：该函数在更改数据库的时区数据文件时很有用。将日期时间表达式解析为timestamp with timezone的值
        或varray包含timestamp with time zone值的对象作为参数。 
        如果datetime值受到新时区数据的影响或将导致“不存在的时间”或“重复的时间”错误，则该函数返回1。否则，它返回0。
ora_dst_convert(datetime_expr [, integer [, integer ]])：该函数使您可以为指定的日期时间表达式指定错误处理。[默认0|1[默认0|1]]
        第一个integer指定0（false）通过返回源datetime值来抑制错误。这是默认值。指定1（true）以允许数据库返回重复时间错误。
        第二个integer指定0（false）通过返回源datetime值来抑制错误。这是默认值。指定1（true）以允许数据库返回不存在的时间错误。
ora_dst_error(datetime_expr)：该函数将日期时间表达式解析为timestamp with time zone值或varray包含timestamp with time zone值的对
        象作为参数，并指示日期时间值是否会导致新时区数据出错。
        返回值为：
                0：datetime值不会导致新时区数据出错。
                1878：datetime值导致“不存在的时间”错误。
                1883：datetime值导致“重复时间”错误。
round(date [, fmt ])：将date以fmt为单位进行四舍五入。以年为单位，将7月以前的舍以后的入。季、月在季度第二个月的第十六天四舍五入
trunc(date [, fmt ])：将date以fmt为单位进行截断。以年为单位，就是每个的1月1日。

sessiontimezone：返回当前会话的时区。
sys_extract_utc(datetime_with_timezone)：从具有时区偏移量或时区区域名称的日期时间值中提取utc（世界标准时间，以前称为格林威治标
        准时间，即时区为0）。如果未指定时区，则datetime与会话时区关联。

sysdate：返回数据库服务器所在的操作系统设置的当前日期和时间。

to_char({ datetime | interval } [, fmt [, 'nlsparam' ] ])：将日期时间datetime或时间区间值interval以fmt格式转换为varchar2的格式。
to_dsinterval ( ' { sql_format | ds_iso_format } ' [ default return_value on conversion error ] )：将其参数转换为interval day to second数据类型的值。
        sql_format::=[+ | -] days hours : minutes : seconds [. frac_secs ]
        ds_iso_format::=[-] p [days d] [t [hours h] [minutes m] [seconds [. frac_secs] s ] ]
        
to_timestamp(char [ default return_value on conversion error ] [, fmt [, 'nlsparam' ] ])：转换char为timestamp数据类型的值。
to_timestamp_tz(char [ default return_value on conversion error ] [, fmt [, 'nlsparam' ] ])：转换char为带时区的timestamp数据类型的值。
to_yminterval ('{ [+|-] years - months | ym_iso_format } ' [ default return_value on conversion error ] )：将其参数转换为interval month to year数据类型的值。
        ym_iso_format::=[-] p [ years y ] [months m] [days d] [t [hours h] [minutes m] [seconds [. frac_secs] s ] ]
tz_offset({ 'time_zone_name'
          | '{ + | - } hh : mi'
          | sessiontimezone
          | dbtimezone
          }
         )：根据语句执行的日期，返回与参数对应的时区偏移量。
*/

WITH dates AS
 (SELECT DATE '2020-01-01' d
  FROM   dual
  UNION
  SELECT DATE '2020-01-10' d
  FROM   dual
  UNION
  SELECT DATE '2020-02-01' d
  FROM   dual
  UNION
  SELECT timestamp'2020-03-03 23:45:00' d
  FROM   dual
  UNION
  SELECT timestamp'2020-04-11 12:34:56' d
  FROM   dual)
SELECT d "Original Date", trunc(d) "Nearest Day, Time Removed", trunc(d, 'ww') "Nearest Week", trunc(d, 'iw') "Start of Week", trunc(d, 'mm') "Start of Month", trunc(d, 'year') "Start of Year"
FROM   dates;

--一般比较函数
/*
greatest
least
*/

--转换函数
/*
asciistr
bin_to_num
cast
chartorowid
compose
convert
decompose
hextoraw
numtodsinterval
numtoyminterval
rawtohex
rawtonhex
rowidtochar
rowidtonchar
scn_to_timestamp
timestamp_to_scn
to_binary_double
to_binary_float
to_blob (bfile)
to_blob (raw)
to_char (bfile|blob)
to_char (character)
to_char (datetime)：
to_char({ datetime | interval } [, fmt [, 'nlsparam' ] ])：将日期时间datetime或时间区间值interval以fmt格式转换为varchar2的格式。
        select to_char(sysdate,'YYYY-MM-DD HH:MI:SS') from dual; 
        select to_char(sysdate,'fmYYYY-MM-DD HH24:MI:SS') from dual; fm去除时间日期前面的0。hh：12小时制；hh24：24小时制。

to_clob (bfile|blob)
to_clob (character)
to_date(char [ default return_value on conversion error ] [, fmt [, 'nlsparam' ] ])：转换字符串char为date数据类型的值。
        select to_date('2020-5-3 12:22:11','fmYYYY-MM-DD HH24:MI:SS') from dual;
        
to_dsinterval
to_lob
to_multi_byte
to_nchar (character)
to_nchar (datetime)
to_nchar (number)
to_nclob
to_number
to_single_byte
to_timestamp
to_timestamp_tz
to_yminterval
treat
unistr
validate_conversion
*/

--大对象函数
/*
bfilename
empty_blob，empty_clob
*/

--收集函数
/*
cardinality
collect
powermultiset
powermultiset_by_cardinality
set
*/

--递阶函数
/*
sys_connect_by_path
*/

--用于sql的oracle机器学习函数
/*
cluster_details
cluster_distance
cluster_id
cluster_probability
cluster_set
feature_compare
feature_details
feature_id
feature_set
feature_value
ora_dm_partition_name
prediction
prediction_bounds
prediction_cost
prediction_details
prediction_probability
prediction_set
*/

--xml函数
/*
depth
existsnode
extract (xml)
extractvalue
path
sys_dburigen
sys_xmlagg
sys_xmlgen
xmlagg
xmlcast
xmlcdata
xmlcolattval
xmlcomment
xmlconcat
xmldiff
xmlelement
xmlexists
xmlforest
xmlisvalid
xmlparse
xmlpatch
xmlpi
xmlquery
xmlsequence
xmlserialize
xmltable
xmltransform
*/

--json函数
/*
the following sql/json functions allow you to query json data:

json_query
json_table
json_value


the following sql/json functions allow you to generate json data:

json_array
json_arrayagg
json_object
json_objectagg
json type constructor
json_scalar
json_serialize
json_transform


the following oracle sql function creates a json data guide:

json_dataguide
*/

--编码与解码函数
/*
decode
dump
ora_hash
standard_hash
vsize
*/

--null相关函数
/*
coalesce
lnnvl
nanvl
nullif
nvl(expr1, expr2)：使您可以在查询结果中用字符串替换null（返回为空白）。
        如果expr1为null，则nvl返回expr2。如果expr1不为null，则nvl返回expr1。跟mysql中的ifnull(expr1,expr2)一样。
nvl2
*/
----null跟任何数字做算术运算，结果都是null

--环境和标识符函数
/*
con_dbid_to_id
con_guid_to_id
con_name_to_id
con_uid_to_id
ora_invoking_user
ora_invoking_userid
sys_context
sys_guid
sys_typeid
uid
user
userenv
*/

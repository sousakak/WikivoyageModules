local value_tfr = ""
local tfr_table = {}
local i18n = {
    css = '駅一覧/styles.css',
    header_num = "駅番号",
    header_name = "駅名",
    header_tfr = "乗り換え路線",
    header_spot = "周辺のスポット",
    property_num = "P154",
    property_tfr = {"P81", "P1192"},
    property_filter = "P642",
    err_nowditem = "ウィキデータIDが指定されていません",
    err_wrongid = "$1番目のウィキデータIDが不正です"
}
local item = mw.wikibase.getEntity("Q124653770")
local function tableLength(tbl)
    local n = 0
    for _ in pairs (tbl) do
        n = n + 1
    end
    return n
end
for p = 1, tableLength(i18n.property_tfr) do
if item:getBestStatements(i18n.property_tfr[p]) ~= nil then
                for value = 1, tableLength(item:getBestStatements(i18n.property_tfr[p])) do
                    local tfr_id = item:getBestStatements(i18n.property_tfr[p])[value]["mainsnak"]["datavalue"]["value"]["id"]
                    local tfr_text
                    if tfr_table[tfr_id] ~= nil then
                        tfr_text = tfr_table[tfr_id]
                    else
                        tfr_text = mw.wikibase.getEntity(tfr_id):getLabel( mw.language.getContentLanguage():getCode() )
                        tfr_table[tfr_id] = tfr_text
                    end
                    value_tfr = value_tfr .. tfr_text .. "、"
                end
            end
            tfr_num = p
        end
mw.log(value_tfr)
mw.log(#value_tfr)
mw.log(mw.ustring.sub(value_tfr, 1, #value_tfr))
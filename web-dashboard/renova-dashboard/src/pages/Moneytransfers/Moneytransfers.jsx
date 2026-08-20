import "./Moneytransfers.css";
import "../Users/Table.css";
//MUI
import Grid from '@mui/material/Grid';
import AccountBalanceWalletIcon from '@mui/icons-material/AccountBalanceWallet';
import PaymentsIcon from '@mui/icons-material/Payments';
import CurrencyExchangeIcon from '@mui/icons-material/CurrencyExchange';
import PendingActionsIcon from '@mui/icons-material/PendingActions';
import RequestQuoteIcon from '@mui/icons-material/RequestQuote';
import RefreshIcon from '@mui/icons-material/Refresh';
import MonetizationOnIcon from '@mui/icons-material/MonetizationOn';
//Components
import Card from "../../components/Card/Card";
import TablePagination from "../../components/Pagination/Pagination";
import Transfermoneydialog from "../../components/Transfermoneydialog/Transfermoneydialog";
import Snackbar from "../../components/Snackbar/Snakbar";
import Button from "../../components/Button/Button";
import Norequest from "../../components/Norequest/Norequest";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useContext,useEffect } from "react";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Api
import {getFinanceRequest} from "../../api/finance";
import {getWaitingReleaseRequest} from "../../api/finance"
import {transferMoneyRequest} from "../../api/finance"
//Utils
import {formatMoney} from "../../utils/formatMoney";

export default function Moneytransfers() {
const [t] = useTranslation();
const [finance_info,setfinance_info]=useState({});
const [transfer_info,settransfer_info]=useState([]);
const [profileload,setprofileload] = useState(false);
const [selectedtransfer_info,setselectedtransfer_info]=useState({});
const {setisloading}=useContext(LoadingContext);
const [showTransfermoneydialog, setshowTransfermoneydialog] = useState(false);
const [page, setPage] = useState(1);
const [msg,setmsg] = useState();
const [isopen, setisopen] = useState(false);
const [severity, setseverity] = useState("");
const rowsPerPage = 12;
let type = {first_payment:t("الدفعة الأولى") , second_payment:t("الدفعة الثانية") , final_payment:t("الدفعة الأخيرة")} 
//ٌRequest
 async function getfinanceAndtransferinfo() {
                setisloading(true);
                try{            
                    let response_finance = await getFinanceRequest();
                    await setfinance_info(response_finance.data);
                    let response_transfer = await getWaitingReleaseRequest();
                    await settransfer_info(response_transfer.data)

                }finally{
                    setisloading(false);
                 }
 }
 async function transferMoney(id,amount) {
     try{
        setprofileload(true);
        let response = await transferMoneyRequest(id,amount);
        setshowTransfermoneydialog(false);
        setmsg(response.data.message);
        setseverity("success");
        await getfinanceAndtransferinfo();
     }catch(error){
        setmsg(error.response.data.message);
        setseverity("error");
     }finally{
        setprofileload(false);
        setisopen(true);
     }
 }
 useEffect(()=>{getfinanceAndtransferinfo();},[]);
const paginatedtransfer_info = transfer_info.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    return (
        <>
        {profileload && <div className="page"></div>}
        {isopen && <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>}
        {showTransfermoneydialog && <Transfermoneydialog
        onApply={(amount) => {transferMoney(selectedtransfer_info.payment_id, amount);}}
        onclose={()=>{setshowTransfermoneydialog(false)}}
        id={selectedtransfer_info.payment_id}
        payment_amount={selectedtransfer_info.payment_amount}
        remaining_amount={selectedtransfer_info.remaining_amount}
        />}
        <Grid container spacing={2}>
            <Grid size={{ xs: 12, sm: 6, md: 2.4 }}>
                <Card number={`$${formatMoney(finance_info?.admin_balance)}`} title={t("رصيد المنصة")} iconright={<AccountBalanceWalletIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
            </Grid>
            <Grid size={{ xs: 12, sm: 6, md: 2.4 }}>
                <Card number={`$${formatMoney(finance_info?.total_received)}`} title={t("إجمالي المبالغ المستلمة")} iconright={<PaymentsIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
            </Grid>
            <Grid size={{ xs: 12, sm: 6, md: 2.4 }}>
                <Card number={`$${formatMoney(finance_info?.total_released)}`} title={t("إجمالي المبالغ المحَولة")} iconright={<CurrencyExchangeIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
            </Grid>
            <Grid size={{ xs: 12, sm: 6, md: 2.4 }}>
                <Card number={finance_info?.pending_payments} title={t("دفعات بانتظار الدفع")} iconright={<RequestQuoteIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
            </Grid>
            <Grid size={{ xs: 12, sm: 6, md: 2.4 }}>
                <Card number={finance_info?.waiting_release} title={t("دفعات بانتظار التحويل")} iconright={<PendingActionsIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
            </Grid>
            <Grid size={12}>
        <div class="table-body">
            <div class="table-header">
                <h3><CurrencyExchangeIcon sx={{ color: "#f07c1f"}}/> {t("التحويلات المالية")}</h3>
                <div class="table-actions">
                    <Button className="refresh" onClick={()=>{getfinanceAndtransferinfo()}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text="تحديث"/>
                </div>
            </div>
            <div class="table-container">
                {transfer_info.length === 0 ? (<Norequest text="لا توجد تحويلات"/>):
                    <table>
                    <thead>
                        <tr>
                            <th>{t("الدفعة")}</th>
                            <th>{t("نوع الدفعة")}</th>
                            <th>{t("اسم المشروع")}</th>
                            <th>{t("المستخدم")}</th>
                            <th>{t("المتعهد")}</th>
                            <th>{t("قيمة الدفعة")}</th>
                            <th>{t("المحول منها")}</th>
                            <th>{t("المتبقي")}</th>
                            <th>{t("الإجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {paginatedtransfer_info.map((transfer) => (
                        <tr key={transfer?.payment_id}>
                            <td>#{transfer?.payment_id}</td> 
                            <td>{type[transfer?.payment_type]}</td>   
                            <td>{transfer?.title}</td>
                            <td>{transfer?.user}</td>
                            <td>{transfer?.contractor}</td>
                            <td>${formatMoney(transfer?.payment_amount)}</td>
                            <td>${formatMoney(transfer?.released_amount)}</td>
                            <td>${formatMoney(transfer?.remaining_amount)}</td>
                            <td>
                                <div className="actions">
                                    <Button className="transfer-money" onClick={()=>{setselectedtransfer_info(transfer);setshowTransfermoneydialog(true)}} icon={<MonetizationOnIcon sx={{fontSize: "19px"}}/>} text="تحويل المبلغ"/>                                           
                                </div>
                            </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
                }
            </div>
                <div className="table-footer">
                  <TablePagination
                    count={Math.ceil(transfer_info.length / rowsPerPage)}
                    page={page}
                    onChange={(event,value)=>setPage(value)}
                  />
            </div>
        </div>
            </Grid>
        </Grid>
        </>
    );
}
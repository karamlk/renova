import "./Financiallogs.css"
//MUI
import RefreshIcon from '@mui/icons-material/Refresh';
import PaidIcon from '@mui/icons-material/Paid';
import VisibilityIcon from '@mui/icons-material/Visibility';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import HistoryIcon from '@mui/icons-material/History';
import Tooltip from '@mui/material/Tooltip';
import IconButton from '@mui/material/IconButton';
import PrintIcon from '@mui/icons-material/Print';
//Components
import TablePagination from "../../components/Pagination/Pagination";
import Filterdialog from "../../components/Filterdialog/Filterdialog";
import Financiallogdialog from "../../components/Financiallogdialog/Financiallogdialog";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Api
import {getpaymentLogsRequest} from "../../api/finance";
import {getFilterPaymentLogsRequest} from "../../api/finance";
import {showPaymentLogsRequest} from "../../api/finance";
//Utils
import {formatMoney} from "../../utils/formatMoney";
//Libraries
import dayjs from "dayjs";
export default function Financiallogs() {
    const [t] = useTranslation();
    const [page, setPage] = useState(1);
    const {setisloading}=useContext(LoadingContext);
    const [paymentlogslist,setpaymentlogslist]=useState([]);
    const [showfilterdialog,setshowfilterdialog] = useState(false);
    const [selectedFilters,setSelectedFilters]=useState({type:"",complained_on_role:""});
    const [profileload,setprofileload] = useState(false);
    const [showfinanciallogdialog,setshowfinanciallogdialog]=useState(false);
    const [paymentlog,setpaymentlog] = useState({});
    let type = {first_payment:t("الدفعة الأولى") , second_payment:t("الدفعة الثانية") , final_payment:t("الدفعة الأخيرة"),release:t("محولة")}
    const rowsPerPage = 12;
    const paginatedpaymentlogs = paymentlogslist.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let FilterPaymentLogs = [
        {
            subtitle: t("نوع الدفعة"),
            icon: <PaidIcon sx={{ color: "#f07c1f",fontSize:20 }} />,
            name: "action",
            options: [
            { value: "", label: t("الكل")},
            { value: "first_payment", label: t("الدفعة الأولى")},
            { value: "second_payment", label: t("الدفعة الثانية")},
            { value: "final_payment", label: t("الدفعة الأخيرة")},
            { value: "release", label: t("محولة")},
            ],
        },
    ]
    //Request
     async function getPaymentLogs() {
                 setisloading(true);
                 try{            
                     let response = await getpaymentLogsRequest();
                     await setpaymentlogslist(response.data.data);
                 }finally{
                     setisloading(false);
                     }
             }
     async function getFilterPaymentLogs(filters) {
             setshowfilterdialog(false);
             setisloading(true);
             try{       
                let response = await getFilterPaymentLogsRequest(filters);
                setpaymentlogslist(response.data.data);
                setPage(1);
                }finally{
                    setisloading(false);
                }
     
         }
     async function showFinancialLog(id){
         setprofileload(true);
         setpaymentlog({}); 
          try{
             let response = await showPaymentLogsRequest(id);
             setpaymentlog(response.data);
             
          }catch(error){
             console.error(error);
          }finally{
             setprofileload(false);
             setshowfinanciallogdialog(true);
          }               
         
          
     }     
    useEffect(()=>{getPaymentLogs();},[]);
    return (
        <>
        {showfilterdialog && (<Filterdialog
         groups={FilterPaymentLogs} 
         title={t("فلترة السجلات")} 
         onClose={() => setshowfilterdialog(false)} 
         onApply={getFilterPaymentLogs}
         selectedFilters={selectedFilters}
         setSelectedFilters={setSelectedFilters}
         onReset={()=>{setSelectedFilters({action:""})}}
         />)}    
        {profileload ? (<div className="page"></div>):(
            showfinanciallogdialog&&<Financiallogdialog
            onClose={() => setshowfinanciallogdialog(false)}
            log_id={paymentlog?.id}
            payment_id={paymentlog?.payment_id}
            log_type={paymentlog?.action}
            amount={paymentlog?.amount}
            log_date={paymentlog?.payment?.created_at}
            from_user={paymentlog?.from_user?.name}
            to_user={paymentlog?.to_user?.name}
            description={paymentlog?.description}
            />
        )}             
        <div class="log-table">
            <div class="log-table-header">
                <h3><HistoryIcon sx={{ color: "#f07c1f" ,fontSize: "28px" }} /> {t("سجل الدفعات")}</h3>
                <div class="log-table-actions">
                    <button className="btn-filter" onClick={() => setshowfilterdialog(true)} ><FilterAltIcon sx={{fontSize: "18px"}}/> {t("فلترة")}</button>
                    <button class="log-btn-outline" onClick={()=>{getPaymentLogs()}}><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>                 
                </div>
            </div>
            <div class="log-table-container">
                {paymentlogslist.length === 0 ? <div className="log-no-requests">لاتوجد سجلات</div>:
                    <table>
                    <thead>
                        <tr>
                            <th>{t("رقم السجل")}</th>
                            <th>{t("رقم الدفعة")}</th>
                            <th>{t("نوع العملية")}</th>
                            <th>{t("من")}</th>
                            <th>{t("إلى")}</th>
                            <th>{t("المبلغ المحول")}</th>
                            <th>{t("الوصف")}</th>
                            <th>{t("تاريخ الدفع")}</th>
                            <th>{t("الإجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {paginatedpaymentlogs.map((paymentlog) => (
                        <tr key={paymentlog?.id}>
                            <td>#{paymentlog?.id}</td>   
                            <td>#{paymentlog?.payment_id}</td>
                            <td><span className={`log-type final ${paymentlog?.action}`}>{type[paymentlog?.action]}</span></td>
                            <td><div className="user-info-td">{paymentlog?.from_user?.name}</div></td>
                            <td><div className="user-info-td">{paymentlog?.to_user?.name}</div></td>
                            <td>${formatMoney(paymentlog?.amount)}</td>
                            <td>{paymentlog?.description}</td>
                        
                            <td>{dayjs(paymentlog?.payment?.created_at).format("YYYY-MM-DD || hh:mm:ss  A")}</td>
                            <td>
                                <div className="log-table-action">
                                    <Tooltip title={t("عرض")} arrow>
                                        <IconButton className="action-btn" sx={{
                                                color: "#2196f3",
                                                backgroundColor: "rgba(33,150,243,0.1)",
                                                "&:hover": {
                                                backgroundColor: "#2196f3",
                                                color: "white",
                                                },
                                            }} onClick={() =>{showFinancialLog(paymentlog?.id);}}>
                                        <VisibilityIcon sx={{ fontSize: 24 }} />
                                        </IconButton>
                                    </Tooltip>
                                    <Tooltip title={t("طباعة")} arrow>
                                        <IconButton className="action-btn" sx={{
                                            color: "#6C63FF", // بنفسجي مائل للأزرق
                                            backgroundColor: "rgba(108,99,255,0.1)",
                                            "&:hover": {
                                                backgroundColor: "#6C63FF",
                                                color: "white",
                                            }}}>
                                        <PrintIcon sx={{ fontSize: 25 }} />
                                        </IconButton>
                                    </Tooltip>                                            
                                </div>
                            </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
                }
            </div>
                <div className="log-table-footer">
                  <TablePagination
                    count={Math.ceil(paymentlogslist.length / rowsPerPage)}
                    page={page}
                    onChange={(event,value)=>setPage(value)}
                  />
            </div>
        </div>

        </>
    )
}
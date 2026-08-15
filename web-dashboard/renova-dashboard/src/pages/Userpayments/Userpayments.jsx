import "./Userpayments.css";
import "../Users/Table.css";
//MUI
import RefreshIcon from '@mui/icons-material/Refresh';
import PaidIcon from '@mui/icons-material/Paid';
import VisibilityIcon from '@mui/icons-material/Visibility';
//Components
import TablePagination from "../../components/Pagination/Pagination";
import Userpaymentdialog from "../../components/Userpaymentdialog/Userpaymentdialog";
import Button from "../../components/Button/Button";
import Norequest from "../../components/Norequest/Norequest";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Api
import {getUserPaymentRequest} from "../../api/finance";
import {showUserPaymentRequest} from "../../api/finance";
//Utils
import {formatMoney} from "../../utils/formatMoney";
//Libraries
import dayjs from "dayjs";
export default function Userpayments() {
    const [t] = useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const [userspaymentlist,setuserspaymentlist]=useState([]);
    const [profileload,setprofileload] = useState(false);
    const [showuserpaymentdialog,setshowuserpaymentdialog]=useState(false);
    const [userpayment,setuserpayment] = useState({});
    const [page, setPage] = useState(1);
    const rowsPerPage = 12;
    const paginateduserspaymentlist = userspaymentlist.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let type = {first_payment:t("الدفعة الأولى") , second_payment:t("الدفعة الثانية") , final_payment:t("الدفعة الأخيرة")}
    let status = {paid:t("مدفوعة"),pending:t("بانتظار الدفع"),released:t("محولة")}
//Request
async function getUserPayment() {
            setisloading(true);
            try{            
                let response = await getUserPaymentRequest();
                await setuserspaymentlist(response.data.data);
            }finally{
                setisloading(false);
                }
    }
async function showUserPayment(id){
    setprofileload(true);
    setuserpayment({}); 
     try{
        let response = await showUserPaymentRequest(id);
        setuserpayment(response.data);
        
     }catch(error){
        console.error(error);
     }finally{
        setprofileload(false);
        setshowuserpaymentdialog(true);
     }               
    
     
}
useEffect(()=>{getUserPayment();},[]);
    return (
        <>
        {profileload ? (<div className="page"></div>):(
            showuserpaymentdialog&&<Userpaymentdialog
            onClose={()=>{setshowuserpaymentdialog(false)}}
            id={userpayment?.id}
            p_type={userpayment?.type}
            amount={userpayment?.amount}
            released_amount={userpayment?.released_amount}
            p_status={userpayment?.status}
            date={userpayment?.paid_at}
            pr_name={userpayment?.form?.reconstruction_request?.title}
            pr_type={userpayment?.form?.reconstruction_request?.type}
            pr_total_cost={userpayment?.form?.total_cost}
            pr_status={userpayment?.form?.reconstruction_request?.status}
            warranty_period={userpayment?.form?.warranty_period}
            execution_duration={userpayment?.form?.execution_duration}
            user_n={userpayment?.user?.name}
            cons_n={userpayment?.form?.contractor?.name}
            eng_n={userpayment?.form?.engineer?.name}
            materials_cost={userpayment?.form?.materials_cost}
            labor_cost={userpayment?.form?.labor_cost}
            profit={userpayment?.form?.profit}
            />
        )}
        <div class="table-body">
            <div class="table-header">
                <h3><PaidIcon sx={{ color: "#f07c1f" ,fontSize: "25px" }} /> {t("دفعات المستخدمين")}</h3>
                <div class="table-actions">
                    <Button className="refresh" onClick={()=>{getUserPayment()}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text="تحديث"/>
                </div>
            </div>
            <div class="table-container">
                {userspaymentlist.length === 0 ? (<Norequest text="لا توجد دفعات"/>):
                    <table>
                    <thead>
                        <tr>
                            <th>{t("الدفعة")}</th>
                            <th>{t("اسم المشروع")}</th>
                            <th>{t("نوع الدفعة")}</th>
                            <th>{t("المستخدم")}</th>
                            <th>{t("المبلغ")}</th>
                            <th>{t("المحول منها")}</th>
                            <th>{t("الحالة")}</th>
                            <th>{t("تاريخ الدفع")}</th>
                            <th>{t("الإجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {paginateduserspaymentlist.map((userspayment) => (
                        <tr key={userspayment?.id}>
                            <td>#{userspayment?.id}</td>   
                            <td>{userspayment?.form?.reconstruction_request?.title}</td>
                            <td><span className={`payment-type ${userspayment?.type}`}>{type[userspayment?.type]}</span></td>
                            <td>{userspayment?.user?.name}</td>
                            <td><span className="amount-paid">${formatMoney(userspayment?.amount)}</span></td>
                            <td><span className="amount-released">${formatMoney(userspayment?.released_amount)}</span></td>
                            <td><span className={`transfer-status-badge paid ${userspayment?.status}`}>{status[userspayment?.status]}</span></td>
                            <td>{dayjs(userspayment?.created_at).format("YYYY-MM-DD")}</td>
                            <td>
                                <div className="actions">
                                    <Button className="view" onClick={()=>{showUserPayment(userspayment.id);}} icon={<VisibilityIcon sx={{fontSize: "19px"}}/>} text="عرض"/>
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
                    count={Math.ceil(userspaymentlist.length / rowsPerPage)}
                    page={page}
                    onChange={(event,value)=>setPage(value)}
                  />
            </div>
        </div>

        </>
    );
}
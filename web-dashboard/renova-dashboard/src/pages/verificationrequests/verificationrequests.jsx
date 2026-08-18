import "./verificationrequests.css";
import "../Users/Table.css";
//MUI
import RefreshIcon from '@mui/icons-material/Refresh';
import CloseIcon from '@mui/icons-material/Close';
import DoneIcon from '@mui/icons-material/Done';
import WarningIcon from '@mui/icons-material/Warning';
import VerifiedUserIcon from '@mui/icons-material/VerifiedUser';
import PictureAsPdfIcon from '@mui/icons-material/PictureAsPdf';
//api
import {getVerificationRequest} from "../../api/verification";
import {approveFoundationRequest} from "../../api/verification";
import {rejectFoundationRequest} from "../../api/verification";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//Components
import TablePagination from "../../components/Pagination/Pagination";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";
import IconBtn from "../../components/IconBtn/IconBtn";
import Button from "../../components/Button/Button";
import Norequest from "../../components/Norequest/Norequest";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Libraries
import dayjs from "dayjs";

export default function Verificationrequests() {
    const {setisloading}=useContext(LoadingContext);
    const {t} = useTranslation();
    const [selectedverification, setSelectedverification] = useState(null);
    const [showapproveconfirmdialog, setshowapproveconfirmdialog] = useState(false);
    const [showrejectconfirmdialog, setshowrejectconfirmdialog] = useState(false);
    const [verificationList,setverificationList]=useState([]);
    const [page, setPage] = useState(1);
    const [isopen, setisopen] = useState(false);
    const [severity, setseverity] = useState("");
    const [msg, setmsg] = useState("");
    const [profileload,setprofileload] = useState(false);
    const rowsPerPage = 12;
    const paginatedVerification = verificationList.slice((page - 1) * rowsPerPage , page * rowsPerPage);
        //Requests
        async function getVerificationList(){
            setisloading(true);
            try{
                let response=await getVerificationRequest();
                setverificationList(response.data);
            }catch(error){
                console.log(error);
            }finally{
                setisloading(false);
            }
        }
        async function approveVerification(id){
            setprofileload(true);
            try{
                let response = await approveFoundationRequest(id);
                setmsg(response.data.message);
                setseverity("success");
                await getVerificationList();
                setprofileload(false);
                setisopen(true);
            }catch(error){
                setprofileload(false);
                setseverity("error");
                setmsg(error.response.data.message);
                setisopen(true);
            }
        }
        async function rejectVerification(id){
            setprofileload(true);
            try{
                let response = await rejectFoundationRequest(id);
                setmsg(response.data.message);
                setseverity("success");
                await getVerificationList();
                setprofileload(false);
                setisopen(true);
            }catch(error){
                setprofileload(false);
                setseverity("error");
                setmsg(error.response.data.message);
                setisopen(true);
            }
        }
        useEffect(() => {
            getVerificationList();
        }, []);
    return (
    <div>
        {showapproveconfirmdialog && (<Confirmdialog
         icon={<VerifiedUserIcon sx={{ color: "#4CAF50" ,fontSize:65 }}/>}
         title={t("تأكيد القبول")}
         message={t("هل تريد قبول هذا الطلب؟")}
         name_btn1={t("إلغاء")}
         btnColor={"#4CAF50"}
         name_btn2={t("قبول")}
         onClose={() => setshowapproveconfirmdialog(false)}
         onConfirm={() =>{approveVerification(selectedverification)}}
        />)}
        {showrejectconfirmdialog && (<Confirmdialog
         icon={<WarningIcon sx={{ color: "#e53935" ,fontSize:65 }}/>}
         title={t("تأكيد الرفض")}
         message={t("هل تريد رقض هذا الطلب؟")}
         name_btn1={t("إلغاء")}
         btnColor={"#e53935"}
         name_btn2={t("رفض")}
         onClose={() => setshowrejectconfirmdialog(false)}
         onConfirm={() =>{rejectVerification(selectedverification)}}
        />)}
        {profileload && (<div className="page"></div>)}

    <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>
    <div className="table-body">
                <div className="table-header">
                    <h3><VerifiedUserIcon sx={{ color: "#f07c1f" , fontSize:23}}/> {t("طلبات التوثيق")}</h3>
                    <div className="table-actions">
                        <Button className="refresh" onClick={()=>{getVerificationList();setPage(1);}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text={"تحديث"}/>
                    </div>
                </div>
                {verificationList.length===0?(<Norequest text="لا يوجد طلبات"/>):(
                <div className="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>{t("الرقم")}</th>
                                <th>{t("اسم المؤسسة")}</th>
                                <th>{t("الوصف")}</th>
                                <th>{t("رقم الترخيص")}</th>
                                <th>{t("الحالة")}</th>
                                <th>{t("سبب الرفض")}</th>
                                <th>{t("تاريخ الإنشاء")}</th>
                                <th>{t("الوثائق")}</th>
                                <th>{t("الاجراءات")}</th>
                            </tr>
                        </thead>
                       <tbody>
                        {paginatedVerification.map((verification) => {
                            return(<tr key={verification?.id}>
                            <td>{verification?.id}</td>
                            <td>{verification?.foundation_name}</td>
                            <td>{verification?.description}</td>
                            <td>{verification?.registration_number}</td>
                            <td>{verification?.status}</td>
                            <td>{(verification?.rejection_reason === null) ?  "-" : verification?.rejection_reason}</td>
                            <td>{dayjs(verification?.created_at).format("YYYY-MM-DD")}</td>
                            <td>
                                <IconBtn name={"عرض PDF"} clr={"#e53935"} bgc={"rgba(229,57,53,0.1)"} h_clr={"white"} h_bgc={"#e53935"}  onClick={() => window.open(verification?.documents?.full_document, "_blank")} icon={<PictureAsPdfIcon sx={{ fontSize:28}} />} />
                            </td>
                            <td>
                                <div className="actions">
                                <IconBtn name={"قبول الطلب"} clr={"#4CAF50"} bgc={"rgba(76,175,80,0.1)"} h_clr={"white"} h_bgc={"#4CAF50"} icon={<DoneIcon sx={{fontSize: 24}}/>} onClick={()=>{setSelectedverification(verification?.id);setshowapproveconfirmdialog(true);}}/>
                                <IconBtn name={"رفض الطلب"} clr={"#e53935"} bgc={"rgba(229,57,53,0.1)"} h_clr={"white"} h_bgc={"#e53935"} icon={<CloseIcon sx={{fontSize: 24}}/>} onClick={()=>{setSelectedverification(verification?.id);setshowrejectconfirmdialog(true);}}/>
                                </div>
                            </td>
                            </tr>)
                            
                        })}
                        </tbody>
                    </table>
                </div>
                )}
                <div className="table-footer">
                        <TablePagination
                          count={Math.ceil(verificationList.length / rowsPerPage)}
                          page={page}
                          onChange={(event,value)=>setPage(value)}
                        />
                </div>
            </div>
    </div>);
}
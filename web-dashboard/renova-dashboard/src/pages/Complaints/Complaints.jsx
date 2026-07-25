import "./Complaints.css";
//MUI Icons
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import FeedbackIcon from '@mui/icons-material/Feedback';
import ArchiveIcon from '@mui/icons-material/Archive';
import CloseIcon from '@mui/icons-material/Close';
import DoneIcon from '@mui/icons-material/Done';
import WarningIcon from '@mui/icons-material/Warning';
import PersonIcon from '@mui/icons-material/Person';
//api
import {getComplaintsRequest} from "../../api/complaints"
import {getFilterComplaintsRequest} from "../../api/complaints"
import {patchComplaintRequest} from "../../api/complaints";
import {archiveComplaintsRequest} from "../../api/complaints";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//Components
import TablePagination from "../../components/Pagination/Pagination";
import Filterdialog from "../../components/Filterdialog/Filterdialog";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";
import Complainthandlingdialog from "../../components/Complainthandlingdialog/Complainthandlingdialog"
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Libraries
import dayjs from "dayjs";

export default function Complaints() {
    const {t}=useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const [complaintsList,setComplaintsList]=useState([]);
    const [selectedComplaint, setSelectedComplaint] = useState(null);
    const [showconfirmdialog, setshowconfirmdialog] = useState(false);
    const [isopen, setisopen] = useState(false);
    const [severity, setseverity] = useState("");
    const [msg, setmsg] = useState("");
    const [profileload,setprofileload] = useState(false);
    const [page, setPage] = useState(1);
    const [showfilterdialog,setshowfilterdialog] = useState(false);
    const [selectedFilters,setSelectedFilters]=useState({type:"",complained_on_role:""});
    const [showresolvedialog, setshowresolvedialog] = useState(false);
    const [showarchivedialog, setshowarchivedialog] = useState(false);
    const rowsPerPage = 12;
    const paginatedComplaints = complaintsList.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let role = { 2:t("المستخدم"), 3:t("المتعهد"), 4:t("المهندس")}
    let type = { no_show:t("عدم الحضور"),general:t("عامة")}
    let status = { open:t("مفتوحة"), resolved:t("تمت المعالجة"), dismissed:t("مرفوضة") }
    let FilterComplaints = [
        {
            subtitle: "نوع الشكوى",
            icon: <FeedbackIcon sx={{ color: "#f07c1f",fontSize:20 }} />,
            name: "type",
            options: [
            { value: "", label: "الكل"},
            { value: "general", label: "عامة"},
            { value: "no_show", label: "عدم الحضور"},
            ],
        },{
            subtitle: "نوع المشكي عليه",
            icon: <PersonIcon sx={{ color: "#f07c1f",fontSize:20 }} />,
            name: "complained_on_role",
            options: [
            { value: "", label: "الكل"},
            { value: "contractor", label: "متعهد"},
            { value: "engineer", label: "مهندس"},
            { value: "user", label: "مستخدم"},
            ],
        },
    ]
    //Requests
    async function getComplaintsList(){
        setisloading(true);
        try{
            let response=await getComplaintsRequest();
            setComplaintsList(response.data.data);
        }catch(error){
            console.log(error);
        }finally{
            setisloading(false);
        }
    }
    async function getFilterComplaints(filters) {
        setshowfilterdialog(false);
        setisloading(true);
        await new Promise(resolve => setTimeout(resolve, 1500));
        try{       
    
                let response = await getFilterComplaintsRequest(filters);
                setComplaintsList(response.data.data);
                setPage(1);
            }finally{
                setisloading(false);
             }

    }   
    async function dismissComplaint(id,status,admin_processing_note,penalty_percentage){
       setshowconfirmdialog(false);
       setprofileload(true);
       try{
        let response = await patchComplaintRequest(id,status,admin_processing_note,penalty_percentage);
        setmsg(response.data.message);
        setseverity("success");
        await getComplaintsList();
       }catch(error){
        console.log(error);
       }finally{
        setisopen(true);
        setprofileload(false);      
       }
    }
    async function resolveComplaint(id,status,admin_processing_note,penalty_percentage=""){
        setshowresolvedialog(false);
        setprofileload(true);
        try{
         let response = await patchComplaintRequest(id,status,admin_processing_note,penalty_percentage);
         setmsg(response.data.message);
         setseverity("success");
         await getComplaintsList();
        }catch(error){
         console.log(error);
        }finally{
         setisopen(true);
         setprofileload(false);      
        }
    }
    async function archiveComplaint(type,id){
        setshowarchivedialog(false);
        setprofileload(true);
        try{
         await archiveComplaintsRequest(type,id);
         setmsg(t("تم ارشفة الشكوى بنجاح"));
         setseverity("success");
         await getComplaintsList();
        }catch(error){
         console.log(error);
        }finally{
         setisopen(true);
         setprofileload(false);      
        }
    }  
    useEffect(()=>{getComplaintsList();},[]);
    return(
        <div>
        {showfilterdialog && (<Filterdialog
         groups={FilterComplaints} 
         title={"فلترة الشكاوى"} 
         onClose={() => setshowfilterdialog(false)} 
         onApply={getFilterComplaints}
         selectedFilters={selectedFilters}
         setSelectedFilters={setSelectedFilters}
         onReset={()=>{setSelectedFilters({type:"",complained_on_role:""})}}
         />)}
        {showconfirmdialog && (<Confirmdialog
         icon={<WarningIcon sx={{ color: "#e53935" ,fontSize:65 }}/>}
         title={t("تأكيد الرفض")}
         message={t("هل تريد رفض هذه الشكوى؟")}
         name_btn1={t("إلغاء")}
         btnColor={"#e53935"}
         name_btn2={t("رفض")}
         onClose={() => setshowconfirmdialog(false)}
         onConfirm={() => dismissComplaint(selectedComplaint?.id,"dismissed","","")}
        />)}
        {showresolvedialog && (<Complainthandlingdialog
        id={selectedComplaint?.id}
        complainant_name={selectedComplaint?.complainant?.name}
        complainton_name={selectedComplaint?.complained_on?.name}
        onApply={(data) => {resolveComplaint(selectedComplaint?.id,"resolved",data.admin_processing_note,data.penalty_percentage)}}
        onClose={() => setshowresolvedialog(false)}
        />)}
        {showarchivedialog && (<Confirmdialog
        icon={<ArchiveIcon sx={{ color: "#f07c1f" ,fontSize:65 }}/>}
         title={t("تأكيد الأرشفة")}
         message={t("هل تريد أرشفة هذه الشكوى؟")}
         name_btn1={t("إلغاء")}
         btnColor={"#f07c1f"}
         name_btn2={t("أرشفة")}
         onClose={() => setshowarchivedialog(false)}
         onConfirm={() => {
            if(selectedComplaint?.type==="no_show"){
                archiveComplaint("no-show-warnings",selectedComplaint?.id)
            }else{
                archiveComplaint("complaints",selectedComplaint?.id)
            }
         }}
        />)}
        {profileload && (<div className="page"></div>)}
            <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>
        
            <div className="complaints-table">
            <div className="complaints-table-header">
                <h3><FeedbackIcon sx={{ color: "#f07c1f" , fontSize:23}}/> {t("شكاوى المستخدمين")}</h3>
                <div className="complaints-table-actions">
                    <button className="complaints-btn-filter" onClick={() => setshowfilterdialog(true)}><FilterAltIcon sx={{fontSize: "18px"}}/> {t("فلترة")}</button>
                    <button className="complaints-btn-refresh" onClick={()=>{getComplaintsList();setPage(1);}}><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>
                </div>
            </div>
            {complaintsList.length===0?(<div className="no-requests">لاتوجد شكاوى</div>):(
                            <div className="complaints-table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{t("الرقم")}</th>
                            <th>{t("مقدم الشكوى")}</th>
                            <th>{t("المشكي عليه")}</th>
                            <th>{t("الشكوى")}</th>
                            <th>{t("نوع الشكوى")}</th>
                            <th>{t("تاريخ الشكوى")}</th>
                            <th>{t("حالة الشكوى")}</th>
                            <th>{t("عدد الشكاوى")}</th>
                            <th>{t("الاجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {paginatedComplaints.map((complaint) => {
                        return(<tr key={complaint?.id}>
                        <td>{complaint?.id}</td>
                        <td>{role[complaint?.complainant_role_id]} :{complaint?.complainant.name}</td>
                        <td>{role[complaint?.complained_on_role_id]} :{complaint?.complained_on.name}</td>
                        <td>{complaint?.reason}</td>
                        <td>{type[complaint?.type]}</td>
                        <td>{dayjs(complaint?.created_at).format("YYYY-MM-DD")}</td>
                        <td>{complaint.status?status[complaint?.status]:t("تمت المعالجة تلقائياً")}</td>
                        <td>{complaint?.complained_on.complaints_count}</td>
                        <td>
                            <div className="complaints-actions">
                            {/* زر العرض */}
                            <Tooltip title={t("عرض")} arrow>
                                <IconButton className="action-btn" sx={{
                                        color: "#2196f3",
                                        backgroundColor: "rgba(33,150,243,0.1)",
                                        "&:hover": {
                                        backgroundColor: "#2196f3",
                                        color: "white",
                                        },
                                    }} >
                                        <VisibilityIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>
                            {complaint.status==="open"?(
                                <>
                                <Tooltip title={t("قبول الشكوى")} arrow>
                                    <IconButton className="action-btn" sx={{
                                        color: "#4CAF50",
                                        backgroundColor: "rgba(76,175,80,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#4CAF50",
                                            color: "white",
                                        },
                                    }} onClick={()=>{setSelectedComplaint(complaint);setshowresolvedialog(true)}}>
                                        <DoneIcon sx={{ fontSize: 24 }} />
                                    </IconButton>
                                </Tooltip>

                            <Tooltip title={t("رفض الشكوى")} arrow>
                                <IconButton className="action-btn" sx={{
                                    color: "#e53935",
                                    backgroundColor: "rgba(229,57,53,0.1)",
                                    "&:hover": {
                                        backgroundColor: "#e53935",
                                        color: "white",
                                    },
                                }} onClick={()=>{setSelectedComplaint(complaint);setshowconfirmdialog(true);}} >
                                    <CloseIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>
                            </>
                            ):(<></>)}
                            {(complaint.status==="resolved"||complaint.status==="dismissed"||!complaint.status)?(
                                <Tooltip title={t("أرشفة")} arrow>
                                    <IconButton className="action-btn" sx={{
                                        color: "#FF9800",
                                        backgroundColor: "rgba(255,152,0,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#FF9800",
                                            color: "white",
                                        },
                                    }} onClick={()=>{setSelectedComplaint(complaint);setshowarchivedialog(true)}}>
                                        <ArchiveIcon sx={{ fontSize: 24 }} />
                                    </IconButton>
                                </Tooltip>
                            ):(<></>)}
                            </div>
                        </td>
                        </tr>)
                        
                    })}
                    </tbody>
                </table>
            </div>
            )}
            <div className="complaints-table-footer">
                    <TablePagination
                      count={Math.ceil(complaintsList.length / rowsPerPage)}
                      page={page}
                      onChange={(event,value)=>setPage(value)}
                    />
            </div>
        </div>
        
        </div>
    )
}
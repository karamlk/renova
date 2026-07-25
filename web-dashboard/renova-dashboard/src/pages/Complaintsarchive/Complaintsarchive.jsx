import "./Complaintsarchive.css";
//MUI Icons
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import FeedbackIcon from '@mui/icons-material/Feedback';
import PersonIcon from '@mui/icons-material/Person';
//api
import {getComplaintsArchiveRequest} from "../../api/complaints"
import {getFilterComplaintsRequest} from "../../api/complaints"
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//Components
import TablePagination from "../../components/Pagination/Pagination";
import Filterdialog from "../../components/Filterdialog/Filterdialog";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Libraries
import dayjs from "dayjs";
export default function Complaintsarchive() {
    const {t}=useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const [complaintsList,setComplaintsList]=useState([]);
    const [page, setPage] = useState(1);
    const [showfilterdialog,setshowfilterdialog] = useState(false);
    const [selectedFilters,setSelectedFilters]=useState({type:"",complained_on_role:""});
    
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
    async function getComplaintsArchiveList(){
        setisloading(true);
        try{
            let response=await getComplaintsArchiveRequest();
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


    useEffect(()=>{getComplaintsArchiveList();},[]);
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
       
            <div className="complaints-table">
            <div className="complaints-table-header">
                <h3><FeedbackIcon sx={{ color: "#f07c1f" , fontSize:23}}/> {t("أرشيف الشكاوى")}</h3>
                <div className="complaints-table-actions">
                    <button className="complaints-btn-filter" onClick={() => setshowfilterdialog(true)}><FilterAltIcon sx={{fontSize: "18px"}}/> {t("فلترة")}</button>
                    <button className="complaints-btn-refresh" onClick={()=>{getComplaintsArchiveList();setPage(1);}}><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>
                </div>
            </div>
            {complaintsList.length===0?(<div className="no-requests">لاتوجد شكاوى مؤرشفة</div>):(
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
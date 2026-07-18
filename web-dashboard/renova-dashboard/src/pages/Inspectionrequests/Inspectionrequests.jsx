import "./Inspectionrequests.css";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//MUI Icons
import LocationOnIcon from '@mui/icons-material/LocationOn';
import AssignmentIcon from '@mui/icons-material/Assignment';
import RefreshIcon from '@mui/icons-material/Refresh';
import EngineeringIcon from '@mui/icons-material/Engineering';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import Avatar from "@mui/material/Avatar";
//api
import {getInspectionRequest} from "../../api/inspection";
import {getEngineersRequest} from "../../api/inspection";
import {chooseEngineerRequest} from "../../api/inspection"
//Components
import Engineerlistdialog from "../../components/Engineerlistdialog/Engineerlistdialog";
import Snackbar from "../../components/Snackbar/Snakbar";
import TablePagination from "../../components/Pagination/Pagination";
//Libraries
import dayjs from "dayjs";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
export default function Inspectionrequests() {
    const [t]=useTranslation();
    const [inspections, setInspections] = useState([]);
    const [engineers, setEngineers] = useState([]);
    const [showenglistdialog, setshowenglistdialog] = useState(false);
    const [selectedEngineer, setSelectedEngineer] = useState(null);
    const [selectedInspection, setSelectedInspection] = useState(null);
    const [msg,setmsg]=useState("");
    const [isopen, setisopen] = useState(false);
    const [listload,setlistload] = useState(false);
    const {setisloading}=useContext(LoadingContext);
    const [page, setPage] = useState(1);
    
    const rowsPerPage = 12;
    const paginatedInspection = inspections.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let type={restoration:t("ترميم") , construction:t("بناء") , finishing:t("إكساء")};
    let status={approved:t("مقبول"), rejected:t("مرفوض"), pending:t("قيد الانتظار")}
    let day={sunday:t("الأحد"),monday:t("الاثنين"),tuesday:t("الثلاثاء"),wednesday:t("الأربعاء"),thursday:t("الخميس"),friday:t("الجمعة"),saturday:t("السبت")}
    //Requests
    async function getInspectionList() {
      setisloading(true);
      try{
        let response = await getInspectionRequest();
      setInspections(response.data.data);
      }catch(error){
            console.error(error);
      }finally{
        setisloading(false);
      }
    }

    async function getEngineersList() {
      setlistload(true);
      try{
        let response = await getEngineersRequest();
        setEngineers(response.data.data);
      }catch(error){
            console.error(error);
      }finally{
        setlistload(false);
      }
    }

    async function chooseEngineer(Insp_id,Eng_id) {
      setshowenglistdialog(false);  
      setlistload(true);
      try{
        let response = await chooseEngineerRequest(Insp_id,Eng_id);
        getInspectionList();
        setmsg(response?.data?.message);
      }catch(error){
            console.error(error);
      }finally{
        setlistload(false);
        setisopen(true);
        setSelectedEngineer(null);
      }
    }
    useEffect(() => {
      getInspectionList();
    },[]);
    return (
        <div>
            {listload ? (<div className="page"></div>):(
                showenglistdialog && <Engineerlistdialog onClose={() => setshowenglistdialog(false)} onApply={() => chooseEngineer(selectedInspection,selectedEngineer)}>
                  {engineers.map((engineer) => (
                        <div className={`engineer-item ${selectedEngineer === engineer.id ? "selected" : ""}`} key={engineer?.id}>
                            <div className="D-left">
                            {engineer?.profile?.full_image_url?<Avatar  src={engineer?.profile?.full_image_url} alt="img" sx={{ width: 55, height: 55 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"63px" }} />}
                            <div className="info">
                                <div className="name">{engineer?.name}</div>
                                <div className="specialty">مهندس معماري</div>
                            </div>
                            </div>
                            <div className="check">
                                <input type="radio" name="engineer" 
                                    checked={selectedEngineer === engineer.id}
                                    onChange={() => setSelectedEngineer(engineer.id)}/>
                            </div>
                        </div>
                        ))}
                </Engineerlistdialog>)}

        <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={"success"}/>
        <div class="projects-table">
            <div class="table-header">
                <h3><AssignmentIcon sx={{ color: "#f07c1f"}}/> {t("طلبات المعاينة")}</h3>
                <div class="table-actions">
                    <button class="btn-outline" onClick={getInspectionList}><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>
                </div>
            </div>
            <div class="table-container">
                {inspections.length ===0 ? <div className="no-requests">لاتوجد طلبات معاينة</div>:
                    <table>
                    <thead>
                        <tr>
                            <th>{t("#")}</th>
                            <th>{t("اسم المشروع")}</th>
                            <th>{t("صاحب المشروع")}</th>
                            <th>{t("النوع")}</th>
                            <th>{t("تاريخ الطلب")}</th>
                            <th>{t("الموقع")}</th>
                            <th>{t("المتعهد")}</th>
                            <th>{t("يوم المعاينة")}</th>
                            <th>{t("حالة التعيين")}</th>
                            <th>{t("الإجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {paginatedInspection.map((inspection) => (
                        <tr key={inspection?.id}>
                        <td>{inspection?.id}</td>   
                        <td>{inspection?.inspection_request?.request?.title}</td>
                        <td>{inspection?.inspection_request?.request?.user?.name}</td>
                        <td>{type[inspection?.inspection_request?.request?.type]}</td>
                        <td>{dayjs(inspection?.created_at).format("YYYY-MM-DD")}</td>
                        <td><div className="location_project"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{inspection?.inspection_request?.request?.location}</div></td>
                        <td>{inspection?.inspection_request?.contractor?.name}</td>
                        <td>{day[inspection?.schedule?.day_of_week]}<br/>{t("من")} {inspection?.schedule?.start_time} {t("الى")} {inspection?.schedule?.end_time}</td>
                        <td>{status[inspection?.status]}</td>
                        <td>
                            <button className="open-btn" onClick={()=>{setSelectedInspection(inspection?.id);setshowenglistdialog(true); getEngineersList();}}><EngineeringIcon/>{t("اختيار مهندس")}</button>
                        </td>
                        
                        </tr>
                    ))}
                    </tbody>
                </table>
                }
            </div>
                <div className="table-footer">
                  <TablePagination
                    count={Math.ceil(inspections.length / rowsPerPage)}
                    page={page}
                    onChange={(event,value)=>setPage(value)}
                  />
            </div>
        </div>
        </div>
       
    )
}